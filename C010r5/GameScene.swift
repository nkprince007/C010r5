//
//  GameScene.swift
//  C010r5
//
//  Created by Naveen Kumar Sangi on 7/24/16.
//  Copyright © 2016 Naveen Kumar Sangi. All rights reserved.
//

import SpriteKit

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
    private var scoreLabel: SKLabelNode?
    private var duration: NSTimeInterval = 1.5
    private var rootView: SKView!
    var score = 0 {
        willSet(val) {
            scoreLabel?.text = "\(val)"
            if val % 10 == 0 && duration > 0.5 {
                duration -= 0.075
            }
        }
    }
    
    
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
        rootView = view
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize.init(width: view.frame.width, height: 1), center: CGPoint(x: 0, y: -view.frame.height/2 + 1))
        self.backgroundColor = UIColor.whiteColor()
        physicsWorld.contactDelegate = self
        self.physicsBody?.dynamic = false
        
        //Create the center ball
        let w = (view.frame.size.width + view.frame.size.height ) * 0.1
        bigBall = SKShapeNode.init(rectOfSize: CGSize.init(width: w, height: w), cornerRadius: w * 0.5)
        bigBall?.fillColor = colors[bigBallState]!
        bigBall?.physicsBody = SKPhysicsBody(circleOfRadius: w * 0.5, center: (bigBall?.position)!)
        bigBall?.physicsBody?.pinned = true
        bigBall?.lineWidth = 0.0
        bigBall?.name = "Big"
        bigBall?.position = CGPointMake(view.frame.width/2, view.frame.height/4)
        addChild(bigBall!)
        
        //Create score label
        scoreLabel = SKLabelNode.init(text: "\(score)")
        scoreLabel?.fontSize = 40
        scoreLabel?.zPosition = 2
        scoreLabel?.fontColor = UIColor.whiteColor()
        scoreLabel?.position = CGPointMake(bigBall!.position.x, bigBall!.position.y-scoreLabel!.frame.height/2)
        addChild(scoreLabel!)
        
        createBall()
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if(contact.bodyA.node?.name=="Small" && contact.bodyB.node?.name=="Big" || contact.bodyB.node?.name=="Small" && contact.bodyA.node?.name=="Big") {
            if smallBallState == bigBallState {
                let expand = SKShapeNode.init(circleOfRadius: 10)
                smallBall?.runAction(SKAction.sequence([SKAction.scaleTo(0.0, duration: 0.05),SKAction.removeFromParent()]))
                expand.position = bigBall!.position
                expand.fillColor = UIColor.clearColor()
                expand.strokeColor = bigBall!.fillColor
                expand.lineWidth = 2.0
                expand.runAction(SKAction.sequence([SKAction.group([SKAction.scaleTo(10, duration: 0.25),SKAction.fadeOutWithDuration(0.25)]), SKAction.removeFromParent()]))
                addChild(expand)
                score += 1
                createBall()
            } else {
                createBall()
                //                print("Game Over")
                //                delegate = nil
                //                smallBall?.removeFromParent()
                //                let transition = SKTransition.doorsCloseVerticalWithDuration(0.5)
                //                let scene = GameOverScene()
                //                view?.presentScene(scene,transition: transition)
            }
        }
    }
    
    func createBall() {
        let w = (rootView.frame.width + rootView.frame.height ) * 0.05
        smallBall = SKShapeNode.init(rectOfSize: CGSize.init(width: w, height: w), cornerRadius: w * 0.5)
        smallBallState = (arc4random() % 2 == 0 ? .Blue: .Yellow)
        smallBall?.physicsBody = SKPhysicsBody(circleOfRadius: w * 0.5, center: (smallBall?.position)!)
        smallBall?.lineWidth = 0.0
        smallBall?.name = "Small"
        smallBall?.position = CGPoint(x: CGFloat(arc4random() % UInt32(rootView.frame.width)), y: rootView.frame.height + smallBall!.frame.height)
        smallBall?.physicsBody?.velocity = CGVector(dx: 10, dy: 10)
        smallBall?.physicsBody?.contactTestBitMask = (smallBall?.physicsBody?.collisionBitMask)!
        smallBall?.physicsBody?.mass = 0.0
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, smallBall!.position.x, smallBall!.position.y)
        CGPathAddLineToPoint(path, nil, bigBall!.position.x, bigBall!.position.y)
        let follow = SKAction.followPath(path, asOffset: false, orientToPath: true, duration: self.duration)
        smallBall?.runAction(follow)
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
