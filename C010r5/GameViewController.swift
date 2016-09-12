//
//  GameViewController.swift
//  C010r5
//
//  Created by Naveen Kumar Sangi on 7/24/16.
//  Copyright © 2016 Naveen Kumar Sangi. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

let color = [
    "blue" : UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1.0),
    "cyan" : UIColor(red: 80.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: 1.0)
]

enum GameState {
    case Intro
    case Playing
    case Dead
}

var gameState = GameState.Intro
var backgroundMusic: SKAudioNode!

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = MenuScene()
            scene.scaleMode = .resizeFill
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

public func +(lhs: CGSize, rhs: CGFloat) -> CGSize {
    return CGSize(width: lhs.width+rhs, height: lhs.height+rhs)
}
