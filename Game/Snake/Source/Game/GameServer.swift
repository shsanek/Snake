//
//  GameServer.swift
//  Snake
//
//  Created by Шипин Александр on 18/02/2020.
//  Copyright © 2020 CFT. All rights reserved.
//

import Foundation

class GameServer: IGameController
{

    private var currentGame: CurrentGame?
    private var recordStorage = RecordStorage()

    private var players: [IPlayer] = []
    private var currentPlayer: IPlayer?

    private let config = GameConfig.demo()
    private let sheduler: Scheduler = Scheduler(defaultDelay: 0.5)

    internal func add(player: IPlayer)
    {
        if self.players.contains(where: { $0 === player})
        {
            return
        }
        self.players.append(player)
        player.showMainMenu(with: recordStorage.fectRecords())
    }

    internal func start(with name: String)
    {
        for player in self.players
        {
            player.showWillStart()
        }
        self.sheduler.schedule(delay: TimeInterval(self.config.startDelay), handler: { [weak self] in
            self?.start(name: name)
        })
    }

    internal func moveTo(player: IPlayer, orintation: GameOrintation)
    {
        self.currentGame?.moveTo(orintation: orintation)

//        if self.currentPlayer === player
//        {
//            self.currentGame?.moveTo(orintation: orintation)
//        }
    }

    internal func cancel(player: IPlayer)
    {
        self.sheduler.cancel()
        self.players.removeAll(where: { $0 === player})
        player.showMainMenu(with: self.recordStorage.fectRecords())
        players.forEach { $0.showWating() }
    }

}

extension GameServer
{

    private func start(name: String)
    {
        self.currentGame = CurrentGame(config: self.config, name: name, didLoopHandler: { [weak self] (currentGame, events) in
            guard let self = self, self.currentGame === currentGame else {
                return
            }
            self.didLoop(events, currentGame: currentGame)
        })
        self.showGame(with: [])
        self.currentGame?.start()
        self.currentPlayer = self.players[0]
        return
    }

    private func didLoop(_ events: [GameEvent], currentGame: CurrentGame)
    {
        if currentGame.lives == 0
        {
            self.endGame(currentGame: currentGame)
            return
        }
        for event in events
        {
            if event == .apple, let index = self.players.firstIndex(where: { $0 === self.currentPlayer })
            {
                self.currentPlayer = self.players[(index + 1) % self.players.count]
            }
        }
        self.showGame(with: events)
    }

    private func endGame(currentGame: CurrentGame)
    {
        let record = Record(name: currentGame.name, score: currentGame.score)
        self.recordStorage.appendRecord(record)
        for player in players
        {
            player.showEndGame(EndGame(records: self.recordStorage.fectRecords(), record: record))

        }
        let records = self.recordStorage.fectRecords()
        self.sheduler.schedule(delay: TimeInterval(self.config.startDelay), handler: { [players] in
            for player in players
            {
                player.showMainMenu(with: records)
            }
        })
        self.currentGame = nil
    }

    private func showGame(with events: [GameEvent])
    {
        let objects = self.currentGame?.allObjects ?? []
        let snake = self.currentGame?.snakeObjects ?? []
        let gameState = GameState(nextTime: self.currentGame?.nextTime ?? 0.0,
                                  score: self.currentGame?.score ?? 0,
                                  levels: self.currentGame?.lives ?? 0,
                                  snake: snake,
                                  objects: objects,
                                  events: events)
        for player in players
        {
            if self.currentPlayer !== player
            {
                player.showGame(gameState)
            }
            else
            {
                player.showGame(gameState)
            }
        }
    }

}
