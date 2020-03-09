//
//  UsersValidator.swift
//  2KeyboardsGame
//
//  Created by Павел Бабинцев on 23/05/2019.
//  Copyright © 2019 Павел Бабинцев. All rights reserved.
//

import Foundation

public protocol IUserValidator: class
{
    func validUser(_ userId: String) -> Bool
}

internal final class UserValidator: IUserValidator
{
    private let storage: ScoresStorage
    internal init(storage: ScoresStorage)
    {
        self.storage = storage
    }
    
    internal func validUser(_ userId: String) -> Bool
    {
        if userId.trimmingCharacters(in: .whitespacesAndNewlines).count == 0
        {
            return false
        }
        
        return self.storage.scores.first { $0.name == userId } == nil
    }
}

