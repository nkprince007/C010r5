//
//  MenuScene.swift
//  C010r5
//
//  Created by Naveen Kumar Sangi on 7/26/16.
//  Copyright © 2016 Naveen Kumar Sangi. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    private let duration = 1.0
    private var playLabel: SKLabelNode?
    private var playButton: SKShapeNode?
    private var title: SKLabelNode?
    private var developer: SKLabelNode?
    private var maskDeveloper: SKShapeNode?
    private var lightNode: SKLightNode?
    private weak var rootView: SKView?
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.blackColor()
        rootView = view
        
        playLabel = SKLabelNode(fontNamed: "AmaticSC-Bold")
        playLabel?.fontColor = UIColor.blackColor()
        playLabel?.fontSize = 40
        playLabel?.text = "Play"
        playLabel?.position = CGPointMake(CGRectGetMidX(view.frame), CGRectGetMidY(view.frame))
        playLabel?.zPosition = 2
        playLabel?.runAction(SKAction.fadeOutWithDuration(0.0))
        addChild(playLabel!)
        
        let w = (self.size.width + self.size.height ) * 0.05
        playButton = SKShapeNode(circleOfRadius: w)
        playButton?.position = playLabel!.position
        playButton?.fillColor = UIColor.whiteColor()
        playButton?.runAction(SKAction.scaleTo(0.0, duration: 0.0))
        addChild(playButton!)
        
        title = SKLabelNode(fontNamed: "PartyLetPlain")
        title?.position.x = playButton!.position.x
        title?.position.y = CGRectGetMaxY(view.frame) + 200
        title?.text = "Colors"
        title?.fontSize = 80
        title?.fontColor = UIColor.whiteColor()
        addChild(title!)
        
        developer = SKLabelNode(fontNamed: "PoiretOne-Regular")
        developer?.position.x = title!.position.x
        developer?.position.y = 25
        developer?.fontSize = 16
        developer?.text = "Developed by Naveen Inc."
        addChild(developer!)
        
        maskDeveloper = SKShapeNode(rectOfSize: developer!.frame.size + 20)
        maskDeveloper?.zPosition = 2
        maskDeveloper?.lineWidth = 0
        maskDeveloper?.fillColor = UIColor.blackColor()
        maskDeveloper?.position = developer!.position
        addChild(maskDeveloper!)
        
        playLabel?.runAction(SKAction.fadeInWithDuration(duration*2))
        title?.runAction(SKAction.moveTo(CGPointMake(playButton!.position.x, 2*view.frame.maxY/2.75), duration: duration))
        playLabel?.position.y -= playLabel!.frame.height/2
        playButton?.runAction(SKAction.scaleTo(1.0, duration: duration))
        maskDeveloper?.runAction(SKAction.sequence([SKAction.moveByX(maskDeveloper!.frame.width, y: 0, duration: duration), SKAction.removeFromParent()]))
        
        playButton?.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.scaleTo(1.1, duration: duration),
            SKAction.scaleTo(1.0, duration: duration)
            ])))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            if let btn = playButton, label = playLabel {
                if btn.containsPoint(location) || label.containsPoint(location) {
                    let transition = SKTransition.fadeWithDuration(duration)
                    let move = SKAction.moveTo(playButton!.position + CGPoint(x: 0, y: -self.frame.height/4), duration: duration*0.5)
                    playButton?.runAction(move)
                    playLabel?.runAction(SKAction.fadeOutWithDuration(duration*0.25))
                    title?.runAction(SKAction.moveTo(CGPointMake(title!.position.x,2000), duration: duration*0.25))
                    developer?.runAction(SKAction.moveTo(CGPointMake(developer!.position.x, -100), duration: duration*0.25))
                    
                    // Load the SKScene from 'GameScene.sks'
                    if let scene = SKScene(fileNamed: "GameScene") {
                        transition.pausesOutgoingScene = false
                        transition.pausesIncomingScene = false
                        
                        scene.scaleMode = .ResizeFill
                        rootView?.presentScene(scene, transition: transition)
                    }
                }
            }
        }
    }
    
}
