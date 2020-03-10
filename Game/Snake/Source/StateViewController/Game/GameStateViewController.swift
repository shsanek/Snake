//
//  GameStateViewController.swift
//  Snake
//
//  Created by Шипин Александр on 18/02/2020.
//  Copyright © 2020 CFT. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameStateViewController: BaseStateViewController<SKView>
{

    var scene: GameScene?
    var moveToHandler: ((_ orintation: GameOrintation) -> Void)?

    override func active()
    {
        super.active()
        let scene = GameScene()
        scene.scaleMode = .aspectFit
        self.view.presentScene(scene)
        self.scene = scene
        scene.moveToHandler = { [weak self] orintation in
            self?.moveToHandler?(orintation)
        }
    }

    override func deactive()
    {
        super.deactive()
        self.scene = nil
    }

    func showGameState(_ state: GameState)
    {
        self.scene?.showGame(state)
    }

}
