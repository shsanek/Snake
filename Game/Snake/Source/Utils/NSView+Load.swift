//
//  NSView+Load.swift
//  Snake
//
//  Created by Шипин Александр on 27/02/2020.
//  Copyright © 2020 CFT. All rights reserved.
//

import Cocoa

extension NSView
{

    internal static func load(name: String) -> Self?
    {
        guard let nib = NSNib(nibNamed: "GameView", bundle: nil) else
        {
            return nil
        }
        var topLevelObjects: NSArray? = nil
        assert(nib.instantiate(withOwner: nil, topLevelObjects: &topLevelObjects))
        for object in topLevelObjects ?? []
        {
            if let result = object as? Self
            {
                return result
            }
        }
        return nil
    }

}
