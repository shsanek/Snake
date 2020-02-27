//
//  RecordStorage.swift
//  Snake
//
//  Created by Шипин Александр on 27/02/2020.
//  Copyright © 2020 CFT. All rights reserved.
//

import Foundation

internal final class RecordStorage
{

    private var records: [Record]

    internal init()
    {
        if let data = try? Data(contentsOf: URL(fileURLWithPath: GameConfig.demo().recordsPath))
        {
            self.records = (try? JSONDecoder().decode([Record].self, from: data)) ?? []
        }
        else
        {
            self.records = []
        }
    }

    internal func fectRecords() -> [Record]
    {
        return self.records
    }

    internal func appendRecord(_ record: Record)
    {
        self.records.removeAll(where: { $0.name == record.name })
        self.records.append(record)
        self.records.sort { $0.score > $1.score }
        if let data = try? JSONEncoder().encode(self.records)
        {
            try? data.write(to: URL(fileURLWithPath: GameConfig.demo().recordsPath))
        }
    }

}

