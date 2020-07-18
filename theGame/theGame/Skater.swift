//
//  Skater.swift
//  theGame
//
//  Created by Никита Попов on 13.07.2020.
//  Copyright © 2020 Никита Попов. All rights reserved.
//

import SpriteKit

class Skater: SKSpriteNode {
    var velocity = CGPoint.zero
    var minimumY: CGFloat = 0.0
    var jumpSpeed: CGFloat = 20.0
    var isOnGround = true
    
    func setupPhysicsBody() {
        if let skaterTexture = texture {
        
        physicsBody = SKPhysicsBody(texture: skaterTexture,  size: size)
        physicsBody?.isDynamic = true
        physicsBody?.density = 6.0
        physicsBody?.allowsRotation = false
        physicsBody?.angularDamping = 1.0
        physicsBody?.categoryBitMask = PhysicsCategory.skater
        physicsBody?.collisionBitMask = PhysicsCategory.brick
        physicsBody?.contactTestBitMask = PhysicsCategory.brick |  PhysicsCategory.gem
        }
    }
}
