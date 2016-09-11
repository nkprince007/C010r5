//
//  MenuScene.swift
//  C010r5
//
//  Created by Naveen Kumar Sangi on 7/26/16.
//  Copyright © 2016 Naveen Kumar Sangi. All rights reserved.
//

import SpriteKit
import SafariServices

class MenuScene: SKScene {
    
    private let duration = 1.0
    private var playLabel: SKLabelNode?
    private var playButton: SKShapeNode?
    private var title: SKLabelNode?
    private var developer: SKLabelNode?
    private var maskDeveloper: SKShapeNode?
    private var lightNode: SKLightNode?
    private weak var rootView: SKView?
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.black
        rootView = view
        
        playLabel = SKLabelNode(fontNamed: "AmaticSC-Bold")
        playLabel?.fontColor = UIColor.black
        playLabel?.fontSize = 40
        playLabel?.text = "play"
        playLabel?.position = CGPoint(x: view.frame.midX, y: view.frame.midY)
        playLabel?.zPosition = 2
        playLabel?.run(SKAction.fadeOut(withDuration: 0.0))
        addChild(playLabel!)
        
        let w = (self.size.width + self.size.height ) * 0.05
        playButton = SKShapeNode(circleOfRadius: w)
        playButton?.position = playLabel!.position
        playButton?.fillColor = UIColor.white
        playButton?.run(SKAction.scale(to: 0.0, duration: 0.0))
        addChild(playButton!)
        
        title = SKLabelNode(fontNamed: "PartyLetPlain")
        title?.position.x = playButton!.position.x
        title?.position.y = view.frame.maxY + 200
        title?.text = "colors"
        title?.fontSize = 80
        title?.fontColor = UIColor.white
        addChild(title!)
        
        developer = SKLabelNode(fontNamed: "PoiretOne-Regular")
        developer?.position.x = title!.position.x
        developer?.position.y = 25
        developer?.fontSize = 16
        developer?.text = "developed by Naveen Inc."
        addChild(developer!)
        
        maskDeveloper = SKShapeNode(rectOf: developer!.frame.size + 20)
        maskDeveloper?.zPosition = 2
        maskDeveloper?.lineWidth = 0
        maskDeveloper?.fillColor = UIColor.black
        maskDeveloper?.position = developer!.position
        addChild(maskDeveloper!)
        
        playLabel?.run(SKAction.fadeIn(withDuration: duration*2))
        title?.run(SKAction.move(to: CGPoint(x: playButton!.position.x, y: 2*view.frame.maxY/2.75), duration: duration))
        playLabel?.position.y -= playLabel!.frame.height/2
        playButton?.run(SKAction.scale(to: 1.0, duration: duration))
        maskDeveloper?.run(SKAction.sequence([SKAction.moveBy(x: maskDeveloper!.frame.width, y: 0, duration: duration), SKAction.removeFromParent()]))
        
        playButton?.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.scale(to: 1.1, duration: duration),
            SKAction.scale(to: 1.0, duration: duration)
            ])))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if let btn = playButton, let label = playLabel , btn.contains(location) || label.contains(location) {
                
                let transition = SKTransition.fade(withDuration: duration)
                let move = SKAction.move(to: playButton!.position + CGPoint(x: 0, y: -self.frame.height/4),duration: duration*0.5)
                playButton?.run(move)
                playLabel?.run(SKAction.fadeOut(withDuration: duration*0.25))
                title?.run(SKAction.move(to: CGPoint(x: title!.position.x,y: 2000), duration: duration*0.25))
                developer?.run(SKAction.move(to: CGPoint(x: developer!.position.x, y: -100), duration: duration*0.25))
                
                // Load the SKScene from 'GameScene.sks'
                let scene = GameScene()
                transition.pausesOutgoingScene = false
                transition.pausesIncomingScene = false
                scene.scaleMode = .resizeFill
                rootView?.presentScene(scene, transition: transition)
                
            }
            
            if let label = developer , label.contains(location) {
                guard let url = URL(string: "http://fb.com/naveen.007.prince") else {
                    return
                }
                UIApplication.shared.openURL(url)
            }
        }
    }
    
}
