//
//  MainMenuView.swift
//  Snake
//
//  Created by Шипин Александр on 18/02/2020.
//  Copyright © 2020 CFT. All rights reserved.
//

import Cocoa

class MainMenuView: NSView
{

    var startGameButtonHandler: (() -> Void)?

    @IBAction func pressedButtonStart(_ sender: Any)
    {
        self.startGameButtonHandler?()
    }

}
