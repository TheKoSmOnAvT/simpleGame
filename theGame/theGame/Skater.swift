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
}
