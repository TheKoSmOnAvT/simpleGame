//
//  MenuLayer.swift
//  theGame
//
//  Created by Никита Попов on 18.07.2020.
//  Copyright © 2020 Никита Попов. All rights reserved.
//

import UIKit
import SpriteKit

class MenuLayer: SKSpriteNode {
    func display(message: String, score: Int?) {
        let messageLabel: SKLabelNode = SKLabelNode(text: message)
        let messageX = -frame.width
        let messageY = frame.height / 2.0
        messageLabel.position = CGPoint(x: messageX, y: messageY)
        messageLabel.horizontalAlignmentMode = .center
        messageLabel.fontName = "Courier-Bold"
        messageLabel.fontSize = 48.0
        messageLabel.zPosition = 20
        addChild(messageLabel)
        
        let finalX = frame.width / 2.0
        let messageAction = SKAction.moveTo(x: finalX, duration: 0.3)
        messageLabel.run(messageAction)
        
        
        if let scoreToDisplay = score {
                
       let scoreString = String(format: "Очки:%04d",
        scoreToDisplay)
        let scoreLabel: SKLabelNode = SKLabelNode(text:
                         scoreString)
        let scoreLabelX = frame.width
        let scoreLabelY = messageLabel.position.y - messageLabel.frame.height
        scoreLabel.position = CGPoint(x: scoreLabelX,         y: scoreLabelY)
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.fontName = "Courier-Bold"
        scoreLabel.fontSize = 32.0
        scoreLabel.zPosition = 20
        addChild(scoreLabel)
        let scoreAction = SKAction.moveTo(x: finalX, duration: 0.3)
        scoreLabel.run(scoreAction)
            
        }
    }
}
