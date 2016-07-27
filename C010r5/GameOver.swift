//
//  GameOver.swift
//  C010r5
//
//  Created by Naveen Kumar Sangi on 7/24/16.
//  Copyright © 2016 Naveen Kumar Sangi. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    var score: Int!
    var bestScore: Int!
    
    private var scoreNode: SKShapeNode!
    private var scoreLabel: SKLabelNode!
    private var bestScoreLabel: SKLabelNode!
    
    private var retry: SKNode!
    private var back: SKNode!
    
    override func didMoveToView(view: SKView) {
        
    }
}
