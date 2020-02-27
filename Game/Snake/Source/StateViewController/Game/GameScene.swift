//
//  GameScene.swift
//  Snake
//
//  Created by Шипин Александр on 05/02/2020.
//  Copyright © 2020 CFT. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene
{

    internal var moveToHandler: ((_ orintation: GameOrintation) -> Void)?
    private var spinnyNode : SKShapeNode?
    private lazy var snakeView: SnakeView = {
        let config = GameConfig.demo()
        return SnakeView(elementSize: CGSize(width: self.size.width / CGFloat(config.size.width),
                                             height: self.size.height / CGFloat(config.size.height)),
                         addNewNodeHandler: { [weak self] child in self?.addChild(child) })
    }()

    override init()
    {
        super.init(size: CGSize(width: 1920, height: 1080))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        // Create shape node to use during mouse interaction
        let config = GameConfig.demo()
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize(width: self.size.width / CGFloat(config.size.width), height: self.size.height / CGFloat(config.size.height)), cornerRadius: w * 0.1)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }

    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode
        {
        case 126:
            self.moveToHandler?(.up)
        case 124:
            self.moveToHandler?(.right)
        case 123:
            self.moveToHandler?(.left)
        case 125:
            self.moveToHandler?(.down)
        default:
            break
        }
    }

    override func update(_ currentTime: TimeInterval) {
        print("\(currentTime)")
    }

    func showGame(_ state: GameState)
    {
        print("рисуем состояние")
        let config = GameConfig.demo()
        self.snakeView.show(gameState: state)
        for object in state.objects
        {
            if let n = self.spinnyNode?.copy() as? SKShapeNode {
                n.position = CGPoint(x: self.size.width / CGFloat(config.size.width) * CGFloat(object.position.x),
                                     y: self.size.height / CGFloat(config.size.height) * CGFloat(object.position.y))
                switch object.identifier
                {
                case .apple:
                    n.fillColor = .red
                    self.addChild(n)
                case .trash:
                    n.fillColor = .brown
                    self.addChild(n)
                default:
                    break
                }

            }
        }
    }

}

internal class SnakeView
{

    private let addNewNodeHandler: ((_ node: SKShapeNode) -> Void)
    private let elementSize: CGSize

    private var objects = [SKShapeNode]()
    private lazy var head: SKShapeNode = makeHead()

    internal init(elementSize: CGSize, addNewNodeHandler: @escaping ((_ node: SKShapeNode) -> Void))
    {
        self.addNewNodeHandler = addNewNodeHandler
        self.elementSize = elementSize
    }

    private func makeHead() -> SKShapeNode
    {
//        let path = CGMutablePath()
//        path.addLine(to: CGPoint(x: self.elementSize.width / 2.0, y: self.elementSize.height / 2.0))
//        path.addLine(to: CGPoint(x: self.elementSize.width , y: 0.0))
        let node = SKShapeNode(rectOf: self.elementSize)
        node.fillColor = .cyan
        node.strokeColor = .clear
        return node
    }

    private func makeBody() -> SKShapeNode
    {
        let node = SKShapeNode(rectOf: self.elementSize)
        node.fillColor = .cyan
        node.strokeColor = .clear
        return node
    }

    private func position(_ pos: GamePoint) -> CGPoint
    {
        return CGPoint(x: CGFloat(pos.x) * self.elementSize.width, y: CGFloat(pos.y) * self.elementSize.height)
    }
    private func rotation(_ orintation: GameOrintation?) -> CGFloat
    {
        guard let orintation = orintation else
        {
            return 0
        }
        switch orintation
        {
        case .down:
            return 0
        case .left:
            return CGFloat.pi / 2.0
        case .right:
            return -CGFloat.pi / 2.0
        case .up:
            return CGFloat.pi
        }

    }

    private func animationTime(gameState: GameState) -> Double
    {
        return gameState.nextTime / 3.0
    }

    internal func show(gameState: GameState)
    {
        self.startIfNeeded(gameState: gameState)
        self.moveCurrentElement(gameState: gameState)
        self.addNewElements(gameState: gameState)
    }

    private func moveCurrentElement(gameState: GameState)
    {
        let animationTime = self.animationTime(gameState: gameState)
        for i in 0..<self.objects.count
        {
            let node = self.objects[i]
            let obj = gameState.snake[i]
            let position = self.position(obj.position)
            var actions = [SKAction.move(to: position, duration: animationTime),
                           SKAction.rotate(toAngle: self.rotation(obj.orintation), duration: animationTime)]
            if gameState.events.contains(where: { $0 == .apple })
            {
                let time = animationTime / Double(self.objects.count) / 2.0
                actions.append(SKAction.sequence([SKAction.wait(forDuration: time * 2.0 / 3.0),
                                                  SKAction.scale(by: 1.2, duration: time),
                                                  SKAction.scale(by: 1.0, duration: time)]))
            }
            if gameState.events.contains(where: { $0 == .trash })
            {
                //чень придумать
            }
            node.run(SKAction.group(actions))
        }
    }

    private func addNewElements(gameState: GameState)
    {
        self.startIfNeeded(gameState: gameState)
        let animationTime = self.animationTime(gameState: gameState)
        while gameState.snake.count > self.objects.count
        {
            let obj = gameState.snake[self.objects.count]
            let body = self.makeBody()
            body.position = self.position(obj.position)
            body.xScale = 0.1
            body.yScale = 0.1
            body.alpha = 0.0
            body.run(SKAction.sequence([
                SKAction.wait(forDuration: animationTime),
                SKAction.fadeAlpha(by: 1.0, duration: 0.0),
                SKAction.scale(by: 1.0, duration: gameState.nextTime - animationTime)]))
            self.objects.append(body)
            self.addNewNodeHandler(body)
        }
    }

    private func startIfNeeded(gameState: GameState)
    {
        if objects.count != 0
        {
            return
        }
        self.objects.append(self.head)
        self.addNewNodeHandler(self.head)
        for obj in gameState.snake
        {
            if obj.identifier == .snakeHead
            {
                self.head.position = self.position(obj.position)
                self.head.zRotation = self.rotation(obj.orintation)
            }
            else
            {
                let node = self.makeBody()
                node.position = self.position(obj.position)
                self.addNewNodeHandler(node)
                self.objects.append(node)
            }
        }
    }

}
