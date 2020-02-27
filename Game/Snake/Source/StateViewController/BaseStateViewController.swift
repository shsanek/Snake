//
//  BaseStateViewController.swift
//  Snake
//
//  Created by Шипин Александр on 18/02/2020.
//  Copyright © 2020 CFT. All rights reserved.
//

import Cocoa

class BaseStateViewController<ViewType: NSView>
{

    internal let view: ViewType

    internal init(view: ViewType)
    {
        self.view = view
    }

    func active()
    {
        self.view.isHidden = false
    }

    func deactive()
    {
        self.view.isHidden = true
    }

}
