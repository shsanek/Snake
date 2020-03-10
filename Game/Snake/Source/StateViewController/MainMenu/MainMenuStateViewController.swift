//
//  MainMenuStateViewController.swift
//  Snake
//
//  Created by Шипин Александр on 18/02/2020.
//  Copyright © 2020 CFT. All rights reserved.
//

import Cocoa

final class MainMenuStateViewController: BaseStateViewController<TableViewController>
{

    var startGameHandler: ((_ commandName: String) -> Void)?

    override func active()
    {
        super.active()

        self.view.configure()
        self.view.viewWillAppear()

        self.view.startHandler = { [weak self] name in
            self?.startGameHandler?(name)
        }
    }


    func setRecords(_ records: [Record])
    {
        self.view.showRecords(records.map {TableRecord(name: $0.name, score: $0.score)})
    }

    func setEndGame(_ endGame: EndGame)
    {
        self.view.doEndOfGame(points: endGame.record.score, mistakes: 0, combos: 0)
    }

}

