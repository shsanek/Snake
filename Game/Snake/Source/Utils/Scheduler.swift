//
//  Scheduler.swift
//  Snake
//
//  Created by Шипин Александр on 18/02/2020.
//  Copyright © 2020 CFT. All rights reserved.
//

import Foundation

internal final class Scheduler
{

    internal var isRunning: Bool {
        return self.item != nil
    }
    private let defaultDelay: TimeInterval
    private let needAutoRetain: Bool

    private var autoRetain: Scheduler? = nil
    private var item: DispatchWorkItem?

    internal init(defaultDelay: TimeInterval, needAutoRetain: Bool = false)
    {
        self.defaultDelay = defaultDelay
        self.needAutoRetain = needAutoRetain
    }

    deinit
    {
        self.cancel()
    }

    internal func schedule(delay: TimeInterval, handler: @escaping () -> Void)
    {
        self.item?.cancel()
        if self.needAutoRetain
        {
            self.autoRetain = self
        }
        let item = DispatchWorkItem(block: { [weak self] in
            handler()
            self?.item = nil
            self?.autoRetain = nil
        })
        self.item = item
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: item)
    }

    internal func schedule(handler: @escaping () -> Void)
    {
        self.schedule(delay: self.defaultDelay, handler: handler)
    }

    internal func cancel()
    {
        self.item?.cancel()
        self.item = nil
        self.autoRetain = nil
    }

}
