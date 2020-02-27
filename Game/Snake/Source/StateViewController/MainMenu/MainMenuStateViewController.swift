//
//  MainMenuStateViewController.swift
//  Snake
//
//  Created by Шипин Александр on 18/02/2020.
//  Copyright © 2020 CFT. All rights reserved.
//

import Cocoa

final class MainMenuStateViewController: BaseStateViewController<MainMenuView>
{

    var startGameHandler: ((_ commandName: String) -> Void)?

    override func active()
    {
        super.active()
        self.view.startGameButtonHandler = { [weak self] in
            self?.startGameHandler?("пидоры вперед")
        }
    }

    func setRecords(_ records: [Record])
    {

    }

}

