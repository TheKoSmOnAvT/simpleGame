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
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint.zero
        
        let background = SKSpriteNode(imageNamed: "background")
        let xMid = frame.midX
        let yMid = frame.midY
        background.position = CGPoint(x: xMid, y: yMid)
        addChild(background)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
    }
}
