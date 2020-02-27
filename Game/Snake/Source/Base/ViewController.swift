//
//  ViewController.swift
//  Snake
//
//  Created by Шипин Александр on 05/02/2020.
//  Copyright © 2020 CFT. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController, IPlayer
{

    enum State
    {
        case game
        case wating
        case willStart
        case mainMenu
        case endGameView
    }

    @IBOutlet private var gameContainerView: SKView!
    @IBOutlet private var watingView: NSView!
    @IBOutlet private var willStartView: NSView!
    @IBOutlet private var mainView: MainMenuView!
    @IBOutlet private var endGameView: NSView!

    private lazy var gameViewController = GameStateViewController(view: self.gameContainerView)
    private lazy var watingViewController = WatingStateViewController(view: self.watingView)
    private lazy var willStartViewController = WillStartStateViewController(view: self.willStartView)
    private lazy var mainMenuViewController = MainMenuStateViewController(view: self.mainView)
    private lazy var endGameViewController = EndGameStateViewController(view: self.endGameView)

    private var state: State = .mainMenu {
        didSet {
            if self.state != oldValue {
                self.updateState()
            }
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.updateState()
    }

    func setGameController(_ gameController: IGameController)
    {
        gameController.add(player: self)
        self.mainMenuViewController.startGameHandler = { commandName in
            gameController.start(with: commandName)
        }
        self.gameViewController.moveToHandler = { [weak self] orintation in
            if let self = self {
                gameController.moveTo(player: self, orintation: orintation)
            }
        }
    }

    func showGame(_ state: GameState)
    {
        self.state = .game
        self.gameViewController.showGameState(state)
    }

    func showEndGame(_ endGame: EndGame)
    {
        self.state = .endGameView
        self.endGameViewController.setEndGame(endGame)
    }

    func showWating()
    {
        self.state = .wating
    }

    func showMainMenu(with records: [Record])
    {
        self.mainMenuViewController.setRecords(records)
        self.state = .mainMenu
    }

    func showWillStart()
    {
        self.state = .willStart
    }

    private func updateState()
    {
        self.gameViewController.deactive()
        self.watingViewController.deactive()
        self.willStartViewController.deactive()
        self.mainMenuViewController.deactive()
        self.endGameViewController.deactive()

        switch self.state
        {
            case .game:
                self.gameViewController.active()
            case .wating:
                self.watingViewController.active()
            case .willStart:
                self.willStartViewController.active()
            case .mainMenu:
                self.mainMenuViewController.active()
            case .endGameView:
                self.endGameViewController.active()
        }
    }

}

