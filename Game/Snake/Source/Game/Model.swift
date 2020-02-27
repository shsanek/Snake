//
//  Model.swift
//  Snake
//
//  Created by Шипин Александр on 18/02/2020.
//  Copyright © 2020 CFT. All rights reserved.
//

internal enum GameOrintation: String, Codable
{
    case up
    case left
    case right
    case down

    public enum OrintationType
    {
        case horizontal
        case vertical
    }

    public var orintationType: OrintationType {
        let horizontal: [GameOrintation] = [.left, .right]
        return horizontal.contains(self) ? .horizontal : .vertical
    }
}

internal struct GameSize: Codable, Equatable
{
    var width: Int
    var height: Int
}

internal struct GamePoint: Codable, Equatable
{

    var x: Int
    var y: Int

}

internal struct Object: Codable
{

    enum Identifier: String, Codable
    {
        case snakeBody
        case snakeHead
        case apple
        case trash
        case noArea
    }

    let identifier: Identifier
    var position: GamePoint
    var orintation: GameOrintation?

}

internal struct GameState: Codable
{

    let nextTime: Double
    let score: Int
    let levels: Int
    let snake: [Object]
    let objects: [Object]
    let events: [GameEvent]

}

internal struct Record: Codable
{

    let name: String
    let score: Int

}

internal struct EndGame: Codable
{

    let records: [Record]
    let record: Record

}

enum GameEvent: String, Codable
{
    case lives
    case apple
    case trash
}
