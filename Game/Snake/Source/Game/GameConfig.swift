//
//  GameConfig.swift
//  Snake
//
//  Created by Шипин Александр on 18/02/2020.
//  Copyright © 2020 CFT. All rights reserved.
//

import Cocoa

internal struct GameConfig: Codable
{

    let size: GameSize
    let minLengthForHead: Int
    let stepTime: Double
    let lives: Int
    let startDelay: CGFloat
    let recordsPath: String

}

extension GameConfig
{

    public static func demo() -> GameConfig
    {
        return GameConfig(size: GameSize(width: 32, height: 18),
                          minLengthForHead: 4,
                          stepTime: 0.5,
                          lives: 3,
                          startDelay: 3.0,
                          recordsPath: "records.json")
    }

}

