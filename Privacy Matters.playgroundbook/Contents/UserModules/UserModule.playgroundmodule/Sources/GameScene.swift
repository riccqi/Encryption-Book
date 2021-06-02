//
//  GameScene.swift
//  PlaygroundBook
//
//  Created by Qi on 19/4/21.
//

import SpriteKit
import Foundation
import SwiftUI
import PlaygroundSupport
import AVFoundation


public struct GameView: View {
    public init() {}

    var scene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene.scaleMode = .aspectFit
        return scene
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                if #available(iOS 14.0, *) {
                    SpriteView(scene: scene)
                        .ignoresSafeArea()
                } else {
                    // Fallback on earlier versions
                }
            }
            
        }
    }
}


enum CollisionType: UInt32 {
    case none = 0
    case player = 1
    case server = 2
    case hacker = 4
    case walls = 8
    case projectile = 16
}

public class GameScene: SKScene, SKPhysicsContactDelegate {
    var spritesAdded = [SKSpriteNode]()
    let maxHackerNumber = 5
    var backgroundMusic: AVAudioPlayer?
    var soundEffect: AVAudioPlayer?
    public var isGameOver = false

    let player = SKSpriteNode(imageNamed: "key")
    let particles = SKEmitterNode(fileNamed: "MyParticle")!
    var startLabel: SKLabelNode!
    var subtitleLabel: SKLabelNode!
    var serverLabel: SKLabelNode!
    var label = "" {
        didSet {
            startLabel.text = label
        }
    }
    var sublabel = "" {
        didSet {
            subtitleLabel.text = sublabel
        }
    }
    var serverCounter = 0 {
        didSet {
            serverLabel.text = "\(serverCounter) of 5 Servers Reached"
        }
    }
    
    public override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.friction = 0.0
        physicsBody?.categoryBitMask = CollisionType.walls.rawValue
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        serverLabel = SKLabelNode(fontNamed: "Menlo-Bold")
        serverLabel.text = "0 of 5 Servers Reached"
        serverLabel.zPosition = 10
        serverLabel.fontSize = 50
        serverLabel.fontColor = SKColor.systemBlue
        serverLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 120)
        addChild(serverLabel)
        
        playMusic()
        
        createPlayer()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            startLabel = SKLabelNode(fontNamed: "Menlo-Bold")
            startLabel.text = ""
            startLabel.fontSize = 22
            startLabel.zPosition = 10
            startLabel.fontColor = SKColor.systemBlue
            startLabel.position = CGPoint(x: frame.midX, y: frame.minY + 100)
            
            label = "You are playing as the yellow key, which is your encryption secret key."
            
            subtitleLabel = SKLabelNode(fontNamed: "Menlo-Bold")
            subtitleLabel.text = ""
            subtitleLabel.fontSize = 22
            subtitleLabel.zPosition = 10
            subtitleLabel.fontColor = SKColor.systemBlue
            subtitleLabel.position = CGPoint(x: frame.midX, y: frame.minY + 70)
            
            sublabel = "Hold down on the key and drag it around the screen to navigate."
            
            addChild(subtitleLabel)
            addChild(startLabel)
            
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let wait = SKAction.wait(forDuration: 4)
            startLabel.run(SKAction.sequence([wait, fadeOut]))
            subtitleLabel.run(SKAction.sequence([wait, fadeOut]))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
                startLabel = SKLabelNode(fontNamed: "Menlo-Bold")
                startLabel.text = ""
                startLabel.fontSize = 22
                startLabel.zPosition = 10
                startLabel.fontColor = SKColor.systemOrange
                startLabel.position = CGPoint(x: frame.midX, y: frame.minY + 100)
                
                label = "Your goal is to transport your key to each of the white servers so your friend can recieve it safely."
                
                subtitleLabel = SKLabelNode(fontNamed: "Menlo-Bold")
                subtitleLabel.text = ""
                subtitleLabel.fontSize = 22
                subtitleLabel.zPosition = 10
                subtitleLabel.fontColor = SKColor.systemOrange
                subtitleLabel.position = CGPoint(x: frame.midX, y: frame.minY + 70)
                
                sublabel = "Avoid the orange hackers at all cost."
                
                addChild(subtitleLabel)
                addChild(startLabel)
                let fadeOut = SKAction.fadeOut(withDuration: 1)
                let wait = SKAction.wait(forDuration: 5)
                startLabel.run(SKAction.sequence([wait, fadeOut]))
                subtitleLabel.run(SKAction.sequence([wait, fadeOut]))
            }
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.createServer()
        }
        
        for _ in 0...maxHackerNumber {
            createHacker()
        }
    }
    
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isGameOver else {return}
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            if frame.maxY - 5 > touch.location(in: self).y && touch.location(in: self).y > frame.minY + 5 && frame.maxX - 5 > touch.location(in: self).x && touch.location(in: self).x > frame.minX + 5 {
                    let location = touch.location(in: self)
                    player.run(SKAction.move(to: location, duration: 1))
                }
        }
    }
    
    public override func update(_ currentTime: TimeInterval) {
        if player.position.y < frame.minY + 50 {
            player.position.y = frame.minY + 50
        } else if player.position.y > frame.maxY - 50 {
            player.position.y = frame.maxY - 50
        }
        
        if player.position.x < frame.minX + 50 {
            player.position.x = frame.minX + 50
        } else if player.position.x > frame.maxX - 50 {
            player.position.x = frame.maxX - 50
        }
        
        if serverCounter == 2 || serverCounter == 3 {
              for sprite in spritesAdded {
                  let random = Int.random(in: 0...500)
                  if random == 1 {
                      makeProjectile(sprite: sprite)
                  }
              }
          }
        
        if serverCounter == 4 {
            let random = Int.random(in: 0...10)
            if random == 1 {
                makeProjectile(sprite: spritesAdded[4])
                makeProjectile(sprite: spritesAdded[0])
            }
          }
        
        
        if serverCounter == 5 {
            gameOver(success: true)
            self.view?.isPaused = true
        }
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        let sortedNodes = [nodeA, nodeB].sorted{
            $0.name ?? "" < $1.name ?? ""
        }
        let firstNode = sortedNodes[0]
        let secondNode = sortedNodes[1]
        
        if secondNode.name == "player" && firstNode.name == "hacker" {
            guard !isGameOver else {
                return
            }
            
            if let explosion = SKEmitterNode(fileNamed: "explosion") {
                explosion.position = secondNode.position
                explosion.particleBirthRate = 200
                addChild(explosion)
            }
            playSound(title: "failure.wav")

            gameOver(success: false)
            secondNode.removeFromParent()
        } else if secondNode.name == "player" && firstNode.name == "aweapon" {
            guard !isGameOver else {
                return
            }
            
            if let explosion = SKEmitterNode(fileNamed: "explosion") {
                explosion.position = secondNode.position
                explosion.particleBirthRate = 200
                addChild(explosion)
            }
            playSound(title: "failure.wav")

            gameOver(success: false)
            secondNode.removeFromParent()
        } else if secondNode.name == "server" && firstNode.name == "player" {
            guard !isGameOver else {
                return
            }
            serverCounter += 1
            playSound(title: "success.mp3")
            
            if serverCounter == 2 {
                startLabel = SKLabelNode(fontNamed: "Menlo-Bold")
                startLabel.text = ""
                startLabel.fontSize = 24
                startLabel.fontColor = SKColor.systemOrange
                startLabel.position = CGPoint(x: frame.midX, y: frame.minY + 100)
                startLabel.zPosition = 10
                
                startLabel.removeFromParent()
                subtitleLabel.removeFromParent()
                label = "The hackers are getting smarter! Avoid their white projectiles!"
                
                addChild(startLabel)
                let fadeOut = SKAction.fadeOut(withDuration: 0.3)
                let wait = SKAction.wait(forDuration: 2)
                startLabel.run(SKAction.sequence([wait, fadeOut]))
            }
            
            if serverCounter == 4 {
                startLabel = SKLabelNode(fontNamed: "Menlo-Bold")
                startLabel.text = ""
                startLabel.fontSize = 24
                startLabel.fontColor = SKColor.systemBlue
                startLabel.position = CGPoint(x: frame.midX, y: frame.minY + 100)
                startLabel.zPosition = 10
                
                label = "You're so close! One more server left to reach!"
                
                addChild(startLabel)
                let fadeOut = SKAction.fadeOut(withDuration: 0.3)
                let wait = SKAction.wait(forDuration: 2)
                startLabel.run(SKAction.sequence([wait, fadeOut]))
            }
            
            particles.removeFromParent()
            secondNode.removeFromParent()
            if serverCounter < 5 {
                //https://stackoverflow.com/questions/23377631/how-to-create-a-timer-in-spritekit
                //use this instead for timer
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.createServer()
                }
            } else {
                firstNode.removeFromParent()
            }
        }

    }
    
    func gameOver(success: Bool) {
        if success {
            let winner = SKLabelNode(fontNamed: "Menlo-Bold")
            winner.text = "Key Successfully Transfered"
            //maybe add background and subtext
                //add pop animation?
            winner.fontSize = 80
            winner.zPosition = 10
            winner.fontColor = SKColor.systemGreen
            winner.position = CGPoint(x: frame.midX, y: frame.midY)
            
            addChild(winner)
            backgroundMusic?.setVolume(0, fadeDuration: 1)
            PlaygroundPage.current.assessmentStatus = .pass(message: "### Hooray! You got the key to your friend safely over the network! But to avoid having to do this everytime you send a message, let's look for a better way to encrypt our messages.\n [**Click here to continue**](@next)")
        } else {
            let winner = SKLabelNode(fontNamed: "Menlo-Bold")
            winner.text = "You Have Been Hacked"
            subtitleLabel = SKLabelNode(fontNamed: "Menlo-Bold")
            subtitleLabel.text = ""
            subtitleLabel.fontSize = 30
            subtitleLabel.zPosition = 10
            subtitleLabel.fontColor = SKColor.systemRed
            subtitleLabel.position = CGPoint(x: frame.midX, y: frame.midY - 50)
            
            sublabel = "Stop the playground and run it again to retry. "
                //maybe add background and subtext
            winner.fontSize = 80
            winner.zPosition = 10
            winner.fontColor = SKColor.systemRed
            winner.alpha = 0
            winner.position = CGPoint(x: frame.midX, y: frame.midY)
            
            addChild(subtitleLabel)
            addChild(winner)
            let fadein = SKAction.fadeIn(withDuration: 0.3)
            winner.run(SKAction.sequence([fadein]))
            
            backgroundMusic?.setVolume(0, fadeDuration: 1)
            for sprite in spritesAdded {
                sprite.physicsBody?.applyForce(CGVector(dx: CGFloat(Float.random(in: -5...5)), dy: CGFloat(Float.random(in: -5...5))))
            }
            PlaygroundPage.current
                .assessmentStatus = .fail(hints: ["You need to keep your key moving!","The movement speed of the key increases as you drag it around faster.", "Don't let the white projectiles touch you!", "The hackers have 3 stages of evolution!"], solution: "If you find the hackers too challenging, we can move on first to find a way around this. \n [**Click here to skip**](@next)")
        }
        isGameOver = true
    }
    
    func createPlayer() {
        player.name = "player"
        player.zPosition = 1
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.position = CGPoint(x: frame.minX + 150, y: frame.midY)
        addChild(player)
        
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
        player.physicsBody!.isDynamic = true
        player.physicsBody!.affectedByGravity = false
        player.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        player.physicsBody?.collisionBitMask = CollisionType.hacker.rawValue | CollisionType.projectile.rawValue
        player.physicsBody?.contactTestBitMask = CollisionType.hacker.rawValue | CollisionType.server.rawValue | CollisionType.projectile.rawValue
    }
    
    func createHacker(){
        let hacker = SKSpriteNode(imageNamed: "hacker")
        hacker.name = "hacker"
        hacker.zPosition = 1
        let xPos = CGFloat(Float.random(in: Float(frame.minX+80)...Float(frame.maxX-80)))
        let yPos = CGFloat(Float.random(in: Float(frame.minY+80)...Float(frame.maxY-80)))
        
        hacker.position = CGPoint(x: xPos, y: yPos )
        
        for sprite in spritesAdded {
            while distanceFrom(posA: hacker.position, posB: player.position) < player.size.width * 3 || distanceFrom(posA: hacker.position, posB: sprite.position) < sprite.size.width * 3 || hacker.intersects(sprite) || hacker.intersects(player) {
                hacker.position = CGPoint(x: CGFloat(Float.random(in: Float(frame.minX+80)...Float(frame.maxX-80))), y: CGFloat(Float.random(in: Float(frame.minY+80)...Float(frame.maxY-80))))
            }
        }
        
        addChild(hacker)
        spritesAdded.append(hacker)
        
        hacker.physicsBody = SKPhysicsBody(texture: hacker.texture!, size: hacker.texture!.size())
        
        hacker.physicsBody?.linearDamping = 0.0
        hacker.physicsBody?.angularDamping = 0.0
        hacker.physicsBody?.restitution = 1.0
        hacker.physicsBody?.friction = 0.0
        
        hacker.physicsBody?.applyForce(CGVector(dx: CGFloat(Float.random(in: -10...10)), dy: CGFloat(Float.random(in: -10...10))))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            hacker.physicsBody?.applyForce(CGVector(dx: CGFloat(Float.random(in: -1000...1000)), dy: CGFloat(Float.random(in: -1000...1000))))
            hacker.physicsBody?.applyImpulse(CGVector(dx: CGFloat(arc4random_uniform(10)), dy: CGFloat(arc4random_uniform(10))))
        }
        
        hacker.physicsBody!.affectedByGravity = false
        hacker.physicsBody!.isDynamic = true
        hacker.physicsBody?.categoryBitMask = CollisionType.hacker.rawValue
        hacker.physicsBody?.collisionBitMask = CollisionType.player.rawValue | CollisionType.walls.rawValue | CollisionType.hacker.rawValue | CollisionType.server.rawValue
        hacker.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
            
    }
    
    func distanceFrom(posA: CGPoint, posB: CGPoint) -> CGFloat {
        let aSquared = (posA.x - posB.x) * (posA.x - posB.x)
        let bSquared = (posA.y - posB.y) * (posA.y - posB.y)
        return sqrt(aSquared + bSquared)
    }
    
    func createServer() {
        let server = SKSpriteNode(imageNamed: "server")
        server.name = "server"
        server.zPosition = 2
        let xPos = CGFloat(Float.random(in: Float(frame.minX+100)...Float(frame.maxX-100)))
        let yPos = CGFloat(Float.random(in: Float(frame.minY+100)...Float(frame.maxY-100)))
        
        server.position = CGPoint(x: xPos, y: yPos)
        
        while distanceFrom(posA: server.position, posB: player.position) < 420 {
            server.position = CGPoint(x: CGFloat(Float.random(in: Float(frame.minX+100)...Float(frame.maxX-100))), y: CGFloat(Float.random(in: Float(frame.minY+100)...Float(frame.maxY-100))))
        }
        
        addChild(server)
        
        server.physicsBody = SKPhysicsBody(circleOfRadius: server.size.width * 1)
        server.physicsBody!.isDynamic = false
        server.physicsBody?.categoryBitMask = CollisionType.server.rawValue
        server.physicsBody?.collisionBitMask = CollisionType.hacker.rawValue
        server.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
        
        particles.position = server.position
        particles.zPosition = -1
        addChild(particles)
    }
    
    func playMusic() {
        let path = Bundle.main.path(forResource: "example.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            backgroundMusic = try AVAudioPlayer(contentsOf: url)
            backgroundMusic?.play()
        } catch {
            print("Background music couldn't be played")
        }
    }
    
    func playSound(title: String) {
        let path = Bundle.main.path(forResource: title, ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            soundEffect = try AVAudioPlayer(contentsOf: url)
            soundEffect?.volume = 0.3
            if title == "failure.wav" {
                soundEffect?.volume = 0.7
            }
            soundEffect?.play()
        } catch {
            print("Sound couldn't be played")
        }
    }
    
    func makeProjectile(sprite: SKSpriteNode) {
        let projectile = SKSpriteNode(imageNamed: "spark")
        projectile.size = CGSize(width: size.width*0.01, height: size.height*0.01)
        projectile.name = "aweapon"
        projectile.position = sprite.position
        
        addChild(projectile)
        
        
        let x = projectile.position.x
        let y = projectile.position.y
        
        let xchange = player.position.x-x
        let ychange = player.position.y-y
                
        
        let relativeToStart = CGPoint(x: player.position.x-x, y: player.position.y-y)
        zRotation = atan2(relativeToStart.y, relativeToStart.x)

        let dx = Double(cosf(Float(zRotation)))
        let dy = Double(sinf(Float(zRotation)))
        

        projectile.physicsBody = SKPhysicsBody(rectangleOf: projectile.size)
        projectile.physicsBody?.categoryBitMask = CollisionType.projectile.rawValue
        projectile.physicsBody?.collisionBitMask = CollisionType.player.rawValue
        projectile.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
        projectile.physicsBody?.linearDamping = 0.0
        projectile.physicsBody?.angularDamping = 0.0

        let moveAction = SKAction.move(to: CGPoint(x: 6*xchange,y: 6*ychange), duration: 16)
        projectile.run(SKAction.sequence([moveAction]))
        
        if serverCounter == 4 {
            projectile.physicsBody?.velocity = CGVector(dx: dx*500, dy: dy*500)
        }
        
    }
}




