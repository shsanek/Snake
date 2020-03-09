//
//  Interface.swift
//  Snake
//
//  Created by Шипин Александр on 18/02/2020.
//  Copyright © 2020 CFT. All rights reserved.
//

protocol IPlayer: AnyObject
{

    func showGame(_ state: GameState)
    func showEndGame(_ endGame: EndGame)
    func showWating()
    func showMainMenu(with records: [Record])
    func showWillStart()

}

protocol IGameController
{

    func add(player: IPlayer)
    func start(with name: String)
    func moveTo(player: IPlayer, orintation: GameOrintation)
    func cancel(player: IPlayer)

}
