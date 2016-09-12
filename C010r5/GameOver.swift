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
    
    private var scoreNode: SKLabelNode!
    private var scoreLabel: SKLabelNode!
    private var bestScoreNode: SKLabelNode!
    private var bestScoreLabel: SKLabelNode!
    private var box: SKShapeNode!
    private weak var rootView: SKView?
    
    private var retry: SKNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.black
        rootView = view
        
        scoreLabel = SKLabelNode(fontNamed: "AmaticSC-Bold")
        scoreLabel.fontSize = 25
        scoreLabel.text = "SCORE"
        scoreLabel.fontColor = color["blue"]
        scoreLabel.position = CGPoint(x: view.frame.midX, y: 0.65*view.frame.maxY)
        scoreLabel.run(SKAction.fadeIn(withDuration: 0.5))
        addChild(scoreLabel)
        
        scoreNode = SKLabelNode(fontNamed: "PoiretOne-Regular")
        scoreNode.fontSize = 35
        scoreNode.text = "\(score!)"
        scoreNode.position = CGPoint(x: view.frame.midX, y: 0.55*view.frame.maxY)
        scoreNode.run(SKAction.fadeIn(withDuration: 0.5))
        addChild(scoreNode)
        
        bestScoreLabel = SKLabelNode(fontNamed: "AmaticSC-Bold")
        bestScoreLabel.fontSize = 25
        bestScoreLabel.fontColor = color["blue"]
        bestScoreLabel.text = "BEST SCORE"
        bestScoreLabel.position = CGPoint(x: view.frame.midX, y: 0.85*view.frame.maxY)
        bestScoreLabel.run(SKAction.fadeIn(withDuration: 0.5))
        addChild(bestScoreLabel)
        
        bestScoreNode = SKLabelNode(fontNamed: "PoiretOne-Regular")
        bestScoreNode.fontSize = 30
        //        bestScoreNode.text = "\(bestScore!)"
        bestScoreNode.position = CGPoint(x: view.frame.midX, y: 0.75*view.frame.maxY)
        bestScoreNode.run(SKAction.fadeIn(withDuration: 0.5))
        addChild(bestScoreNode)
        
        var size = rootView!.bounds.size
        let offset : CGFloat = 45
        size.width = size.width - 2*offset
        size.height = size.height - 2*offset - size.height * 3.0/7.0
        let origin = CGPoint(x: offset, y: rootView!.bounds.height/2)
        box = SKShapeNode(rect: CGRect(origin: origin, size: size), cornerRadius: offset/2.0)
        box.lineWidth = 2.0
        box.strokeColor = UIColor.white
        addChild(box)
    }
}
