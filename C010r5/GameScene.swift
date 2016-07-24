//
//  GameScene.swift
//  C010r5
//
//  Created by Naveen Kumar Sangi on 7/24/16.
//  Copyright © 2016 Naveen Kumar Sangi. All rights reserved.
//

import SpriteKit
import GameplayKit

enum BallState{
    case Yellow
    case Blue
}

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

let colors = [
    BallState.Yellow: UIColor.init(colorLiteralRed: 255/255, green: 205/255, blue: 0/255, alpha: 1.0),
    BallState.Blue: UIColor.init(colorLiteralRed: 0/255, green: 118/255, blue: 255/155, alpha: 1.0)]

class GameScene: SKScene, SKPhysicsContactDelegate {

    private var bigBall : SKShapeNode?
    private var smallBall: SKShapeNode?
    
    private var bigBallState = BallState.Blue {
        willSet(value) {
            bigBall?.fillColor = colors[value]!
            bigBall?.runAction(SKAction.colorizeWithColor(colors[value]!, colorBlendFactor: 1.0, duration: 0.25))
        }
    }
    
    private var smallBallState = BallState.Blue {
        willSet(value) {
            smallBall?.fillColor = colors[value]!
        }
    }
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize.init(width: self.frame.width, height: 1), center: CGPoint(x: 0, y: -self.frame.height/2 + 1))
        self.backgroundColor = UIColor.whiteColor()
        physicsWorld.contactDelegate = self
        self.physicsBody?.dynamic = false
        
        //Create the center ball
        let w = (self.size.width + self.size.height ) * 0.1
        bigBall = SKShapeNode.init(rectOfSize: CGSize.init(width: w, height: w), cornerRadius: w * 0.5)
        bigBall?.fillColor = colors[bigBallState]!
        bigBall?.physicsBody = SKPhysicsBody(circleOfRadius: w * 0.5, center: (bigBall?.position)!)
        bigBall?.physicsBody?.dynamic = false
        bigBall?.lineWidth = 0.0
        bigBall?.name = "Big"
        bigBall?.physicsBody?.mass = 100.0
        bigBall?.position = self.position + CGPoint(x: 0, y: -self.frame.height/4)
        addChild(bigBall!)
        
        let field = SKFieldNode.radialGravityField()
        field.animationSpeed = 10.0
        field.smoothness = 1
        field.region = SKRegion(radius: Float(frame.width*3))
        field.position = bigBall!.position
        field.strength = 500.0
        field.enabled = true
        addChild(field)
        
        createBall()
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if(contact.bodyA.node?.name=="Small" && contact.bodyB.node?.name=="Big" || contact.bodyB.node?.name=="Small" && contact.bodyA.node?.name=="Big") {
            if smallBallState == bigBallState {
                let expand = SKShapeNode.init(circleOfRadius: bigBall!.frame.width/2)
                smallBall?.runAction(SKAction.sequence([SKAction.scaleTo(0.0, duration: 0.05),SKAction.removeFromParent()]))
                expand.position = bigBall!.position
                expand.fillColor = UIColor.clearColor()
                expand.strokeColor = bigBall!.fillColor
                expand.lineWidth = 2.0
                expand.runAction(SKAction.sequence([SKAction.group([SKAction.scaleTo(2, duration: 0.5),SKAction.fadeOutWithDuration(0.5)]), SKAction.removeFromParent()]))
                addChild(expand)
                createBall()
            } else {
                print("Game Over")
//                fatalError()
            }
        }
    }
    
    func createBall() {
        let w = (self.size.width + self.size.height ) * 0.05
        smallBall = SKShapeNode.init(rectOfSize: CGSize.init(width: w, height: w), cornerRadius: w * 0.5)
        smallBallState = (arc4random() % 2 == 0 ? .Blue: .Yellow)
        smallBall?.physicsBody = SKPhysicsBody(circleOfRadius: w * 0.5, center: (smallBall?.position)!)
        smallBall?.lineWidth = 0.0
        smallBall?.name = "Small"
        smallBall?.position = CGPoint(x: CGFloat(arc4random() % UInt32(self.frame.width))-self.frame.width/2, y: self.frame.height + smallBall!.frame.height)
        smallBall?.physicsBody?.velocity = CGVector(dx: 10, dy: 10)
        smallBall?.physicsBody?.contactTestBitMask = (smallBall?.physicsBody?.collisionBitMask)!
        smallBall?.physicsBody?.mass = 0.05
        addChild(smallBall!)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        bigBallState = .Yellow
    }
    
    func touchUp(atPoint pos : CGPoint) {
        bigBallState = .Blue
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.locationInNode(self)) }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.locationInNode(self)) }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        for t in touches! { self.touchUp(atPoint: t.locationInNode(self)) }
    }
    
    override func update(currentTime: NSTimeInterval) {
        // Called before each frame is rendered
    }
}
