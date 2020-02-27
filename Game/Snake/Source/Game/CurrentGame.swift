//
//  CurrentGame.swift
//  Snake
//
//  Created by Шипин Александр on 18/02/2020.
//  Copyright © 2020 CFT. All rights reserved.
//

class CurrentGame
{

    internal var nextTime: Double = 1.0
    internal var allObjects: [Object] {
        return (self.dynamicObjects + self.snake.body + [self.snake.head])
    }
    internal var snakeObjects: [Object] {
        return self.snake.body + [self.snake.head]
    }

    internal var lives: Int
    internal let name: String
    internal var score: Int = 0

    private var snake: Snake
    private var dynamicObjects: [Object] = []
    private var numberOfApple: Int = 0

    private let config: GameConfig
    private let loopSheduler: Scheduler = Scheduler(defaultDelay: 0.5)
    private let didLoopHandler: (CurrentGame, [GameEvent]) -> Void

    internal init(config: GameConfig, name: String, didLoopHandler: @escaping (CurrentGame, [GameEvent]) -> Void)
    {
        self.didLoopHandler = didLoopHandler
        self.lives = config.lives
        self.config = config
        let position = GamePoint(x: Int.random(in: 0..<self.config.size.width),
                                 y: Int.random(in: 0..<self.config.size.height))
        self.snake = Snake(head: Object(identifier: .snakeHead, position: position, orintation: .up))
        self.name = name
        self.regenerateApple()
    }

    internal func start()
    {
        self.nextTime = self.config.stepTime
        self.loopSheduler.schedule(delay: self.config.stepTime) { [weak self] in
            self?.loop()
        }
    }

    internal func moveTo(orintation: GameOrintation)
    {
        if orintation.orintationType == self.snake.orintation.orintationType
        {
            return
        }
        print("поворачиваем змейку \(orintation)")
        self.snake.orintation = orintation
    }


    private func loop()
    {
        let events = self.calculationNextPosition(with: self.objectInPosition(self.snake.nextPosition())?.identifier)
        self.didLoopHandler(self, events)
        if self.lives == 0
        {
            return
        }
        var time = self.config.stepTime
        self.nextTime = time
        self.loopSheduler.schedule(delay: time) { [weak self] in
            self?.loop()
        }
    }

    private func calculationNextPosition(with identifier: Object.Identifier?) -> [GameEvent]
    {
        guard let identifier = identifier else
        {
            self.snake.move()
            return []
        }
        var events = [GameEvent]()
        switch identifier
        {
        case .trash:
            self.lives -= 1
            events.append(.trash)
            events.append(.lives)
            self.snake.move()
            self.regenerateTrash()
            self.numberOfApple = 0
        case .apple:
            self.snake.add()
            self.numberOfApple += 1
            self.score += self.addScore(numberOfApple: self.numberOfApple)
            self.regenerateApple()
            self.regenerateTrash()
            events.append(.apple)
        case .snakeBody, .noArea:
            self.lives = 0
            events.append(.lives)
        case .snakeHead:
            break
        }
        return events
    }

    internal func addScore(numberOfApple: Int) -> Int
    {
        return numberOfApple
    }

}

extension CurrentGame
{

    private func randomPosition() -> GamePoint
    {
        let position = GamePoint(x: Int.random(in: 0..<self.config.size.width),
                                 y: Int.random(in: 0..<self.config.size.height))
        return position
    }

    private func shouldCreateObjectInPoint(_ position: GamePoint) -> Bool
    {
        let position = GamePoint(x: Int.random(in: 0..<self.config.size.width),
                                 y: Int.random(in: 0..<self.config.size.height))
        let width = position.x - self.snake.head.position.x
        let height = position.x - self.snake.head.position.x
        return self.objectInPosition(position) == nil && (width * width + height * height) >= self.config.minLengthForHead
    }

    private func objectInPosition(_ position: GamePoint) -> Object?
    {
        if position.x < 0 || position.y < 0 || position.y >= self.config.size.height || position.x >= self.config.size.width
        {
            return Object(identifier: .noArea, position: position, orintation: nil)
        }
        return self.allObjects.first { $0.position == position }
    }

}

extension CurrentGame
{

    private func regenerateApple()
    {
        self.dynamicObjects.removeAll { $0.identifier == .apple }
        while true
        {
            let position = self.randomPosition()
            if self.shouldCreateObjectInPoint(position)
            {
                let apple = Object(identifier: .apple, position: position, orintation: nil)
                self.dynamicObjects.append(apple)
                break
            }
        }
    }

    private func regenerateTrash()
    {
        self.dynamicObjects.removeAll { $0.identifier == .trash }
        for _ in 0..<5
        {
            while true
            {
                let position = self.randomPosition()
                if self.shouldCreateObjectInPoint(position)
                {
                    let trash = Object(identifier: .trash, position: position, orintation: nil)
                    self.dynamicObjects.append(trash)
                    break
                }
            }
        }
    }
}


extension CurrentGame
{

    class Snake
    {

        var orintation: GameOrintation {
            didSet {
                self.head.orintation = self.orintation
            }
        }
        var head: Object
        var body: [Object] = []

        init(head: Object)
        {
            self.head = head
            self.orintation = head.orintation ?? .up
        }

        func move()
        {
            var lastObject = head
            self.head.position = self.nextPosition()
            for index in 0..<body.count
            {
                let currentObject = body[index]
                body[index].position = lastObject.position
                lastObject = currentObject
            }
        }

        func add()
        {
            let bodyObject = Object(identifier: .snakeBody, position: self.head.position, orintation: nil)
            body.insert(bodyObject, at: 0)
            self.head = Object(identifier: .snakeHead, position: self.nextPosition(), orintation: self.orintation)
        }

        func nextPosition() -> GamePoint
        {
            var position = head.position
            switch self.orintation
            {
                case .down: position.y -= 1
                case .up: position.y += 1
                case .right: position.x += 1
                case .left: position.x -= 1
            }
            return position
        }
    }

}
