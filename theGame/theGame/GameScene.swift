//
//  GameScene.swift
//  theGame
//
//  Created by Никита Попов on 12.07.2020.
//  Copyright © 2020 Никита Попов. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let skater: UInt32 = 0x1 << 0
    static let brick: UInt32 = 0x1 << 1
    static let gem: UInt32 = 0x1 << 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    let skater = Skater(imageNamed: "skater")
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    let startingScrollSpeed: CGFloat = 5.0
    var bricks = [SKSpriteNode]()
    var brickSize = CGSize.zero
    var brickLevel = BrickLevel.low
    var scrollSpeed: CGFloat = 5.0
    var lastUpdateTime: TimeInterval?
    
    enum BrickLevel: CGFloat {
        case low = 0.0
        case high = 100.0
    }
    
    
    let gravitySpeed: CGFloat = 1.5
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -6.0)
        physicsWorld.contactDelegate = self
        anchorPoint = CGPoint.zero
        
        let background = SKSpriteNode(imageNamed: "background")
        let xMid = frame.midX
        let yMid = frame.midY
        background.position = CGPoint(x: xMid, y: yMid)
        addChild(background)
        skater.setupPhysicsBody()
        addChild(skater)
        
        let tapMethod = #selector(GameScene.handleTap(tapGesture:))
        let tapGesture = UITapGestureRecognizer(target: self, action: tapMethod)
        view.addGestureRecognizer(tapGesture)
        startGame()
        
    }
    
    @objc func handleTap(tapGesture : UITapGestureRecognizer){
//        if skater.isOnGround {
//            skater.velocity = CGPoint(x: 0.0, y: skater.jumpSpeed)
//            skater.isOnGround = false
//        }
        if skater.isOnGround {
            skater.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 260.0))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        scrollSpeed += 0.01
        var elapsedTime: TimeInterval = 0.0
        if let lastTimeStamp = lastUpdateTime {
            elapsedTime = currentTime - lastTimeStamp
        }
        lastUpdateTime = currentTime
        
        let expectedElapsedTime: TimeInterval = 1.0 / 60.0
        
        let scrollAdjustment = CGFloat(elapsedTime / expectedElapsedTime)
        let currentScrollAmount = scrollSpeed * scrollAdjustment
        updateBricks(withScrollAmount: currentScrollAmount)
         updateSkater()
    }
    
    func resetSkater(){
        let skaterX = frame.midX / 2.0
        let skaterY = skater.frame.height / 2.0 + 64.0
        skater.position = CGPoint(x: skaterX, y: skaterY)
        skater.zPosition = 10
        skater.minimumY = skaterY
        skater.zRotation = 0.0
        skater.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        skater.physicsBody?.angularVelocity = 0.0
    }
    


    func spawnBrick (atPosition position: CGPoint) -> SKSpriteNode {
        let brick = SKSpriteNode(imageNamed: "sidewalk")
        brick.position = position
        brick.zPosition = 8
        addChild(brick)
        brickSize = brick.size
        bricks.append(brick)
        let center = brick.centerRect.origin
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size, center: center)
        brick.physicsBody?.affectedByGravity = false
        brick.physicsBody?.categoryBitMask = PhysicsCategory.brick
        brick.physicsBody?.collisionBitMask = 0
        return brick
    }
    
    func updateSkater() {
//        if !skater.isOnGround {
//            let velocityY = skater.velocity.y - gravitySpeed
//            skater.velocity = CGPoint(x: skater.velocity.x, y: velocityY)
//            let newSkaterY: CGFloat = skater.position.y +  skater.velocity.y
//            skater.position = CGPoint(x: skater.position.x,  y: newSkaterY)
//        }
//
//        if skater.position.y < skater.minimumY {
//            skater.position.y = skater.minimumY
//            skater.velocity = CGPoint.zero
//            skater.isOnGround = true
//        }
        
        if let velocityY = skater.physicsBody?.velocity.dy {
            if velocityY < -100.0 || velocityY > 100.0 {
            skater.isOnGround = false
                
            }
        }
        let isOffScreen = skater.position.y < 0.0 ||  skater.position.x < 0.0
        let maxRotation = CGFloat(GLKMathDegreesToRadians(85.0))
        let isTippedOver = skater.zRotation > maxRotation || skater.zRotation < -maxRotation
        if isOffScreen || isTippedOver {
            gameOver()
            
        }
    }
    
    
     func didBegin(_ contact: SKPhysicsContact) {
        // Проверяем, есть ли контакт между скейтбордисткой и секцией
        if contact.bodyA.categoryBitMask == PhysicsCategory.skater && contact.bodyB.categoryBitMask == PhysicsCategory.brick {
                skater.isOnGround = true
        }
    }
    
    
    func updateBricks(withScrollAmount currentScrollAmount: CGFloat) {
        var farthestRightBrickX: CGFloat = 0.0
         for brick in bricks {
            let newX = brick.position.x - currentScrollAmount
            if newX < -brickSize.width {
                brick.removeFromParent()
                if let brickIndex = bricks.index(of: brick) {
                    bricks.remove(at: brickIndex)
                }
            } else {
                brick.position = CGPoint(x: newX, y: brick.position.y)
                if brick.position.x > farthestRightBrickX { farthestRightBrickX = brick.position.x
                }
            }
        }
        while farthestRightBrickX < frame.width {
            var brickX = farthestRightBrickX + brickSize.width + 1.0
            let brickY = (brickSize.height / 2.0) + brickLevel.rawValue
            let randomNumber = arc4random_uniform(99)
            if randomNumber < 5 {
                let gap = 20.0 * scrollSpeed
                brickX += gap
            }  else if  randomNumber < 10 {
                if brickLevel == .high {
                    brickLevel = .low
                } else if brickLevel == .low {
                    brickLevel = .high
                }
            }
            let newBrick = spawnBrick(atPosition: CGPoint(x: brickX, y: brickY))
            farthestRightBrickX = newBrick.position.x
        }
    }
    
    func startGame() {
        resetSkater()
        scrollSpeed = startingScrollSpeed
        brickLevel = .low
        lastUpdateTime = nil
        for brick in bricks {
            brick.removeFromParent()
        }
        bricks.removeAll(keepingCapacity: true)
    }
    func gameOver() {
        startGame()
        
    }
    
    
}
