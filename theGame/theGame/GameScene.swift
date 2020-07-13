//
//  GameScene.swift
//  theGame
//
//  Created by Никита Попов on 12.07.2020.
//  Copyright © 2020 Никита Попов. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let skater = Skater(imageNamed: "skater")
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var bricks = [SKSpriteNode]()
    var brickSize = CGSize.zero
    var scrollSpeed: CGFloat = 5.0
    var lastUpdateTime: TimeInterval?
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint.zero
        
        let background = SKSpriteNode(imageNamed: "background")
        let xMid = frame.midX
        let yMid = frame.midY
        background.position = CGPoint(x: xMid, y: yMid)
        addChild(background)
        
        resetSkater()
        addChild(skater)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func resetSkater(){
        let skaterX = frame.midX / 2.0
        let skaterY = skater.frame.height / 2.0 + 64.0
        skater.position = CGPoint(x: skaterX, y: skaterY)
        skater.zPosition = 10
        skater.minimumY = skaterY
    }
    


    func spawnBrick (atPosition position: CGPoint) -> SKSpriteNode {
        let brick = SKSpriteNode(imageNamed: "sidewalk")
        brick.position = position
        brick.zPosition = 8
        addChild(brick)
        brickSize = brick.size
        bricks.append(brick)
        return brick
    }
    
    func updateBricks(withScrollAmount currentScrollAmount: CGFloat) {
        
    }
}
