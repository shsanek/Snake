//
//  UsersStorage.swift
//  2KeyboardsGame
//
//  Created by Павел Бабинцев on 23/05/2019.
//  Copyright © 2019 Павел Бабинцев. All rights reserved.
//
public struct NameScore: Codable
{
    let name: String
    let score: Int
    let mistakes: Int
    let combos: Int
}

public protocol IScoresStorageListener: class
{
    func scoresDidUpdated(scores: [NameScore])
}

internal final class ScoresStorage
{
    internal var scores: [NameScore]

    private var listeners = [WeakRef<IScoresStorageListener>]()
 
    internal init()
    {
        self.scores = []
    }


    internal func update(elements: [NameScore])
    {
        self.scores = elements
        self.scoresDidUpdated()
    }
    
    internal func push(element: NameScore)
    {
        if let index = self.scores.firstIndex(where: { $0.score <= element.score })
        {
            self.scores.insert(element , at: index)
        }
        else
        {
            self.scores.append(element)
        }
        self.scoresDidUpdated()
        self.saveData()
    }
    
    internal func addListener(_ listener: IScoresStorageListener)
    {
        self.listeners.append(WeakRef(listener))
    }
    
    private func scoresDidUpdated()
    {
        for listenerRef in self.listeners
        {
            listenerRef.value?.scoresDidUpdated(scores: self.scores)
        }
    }
    
    private func saveData()
    {
    }
}
