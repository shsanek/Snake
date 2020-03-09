//
//  UsersController.swift
//  2KeyboardsGame
//
//  Created by Павел Бабинцев on 09/03/2019.
//  Copyright © 2019 Павел Бабинцев. All rights reserved.
//

import Cocoa

internal final class UsersTableController: NSObject, IScoresStorageListener
{
    private enum CellIdentifiers
    {
        static let IDCell = "IDCellID"
        static let PointsCell = "PointsCellID"
        static let RangCell = "RangCellID"
    }

    private weak var tableView: NSTableView? = nil
    private let storage: ScoresStorage
    internal init(storage: ScoresStorage)
    {
        self.storage = storage
        super.init()
        self.storage.addListener(self)
        
    }
    
    internal func setTableView(view: NSTableView)
    {
        view.delegate = self
        view.dataSource = self
        
        self.tableView = view
    }
    
    internal func scoresDidUpdated(scores: [NameScore])
    {
        self.tableView?.reloadData()
    }

}

extension UsersTableController: NSTableViewDelegate, NSTableViewDataSource
{

    internal func numberOfRows(in tableView: NSTableView) -> Int
    {
        return self.storage.scores.count
    }

    internal func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat
    {
        return 34.0;
    }

    internal func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        guard row < self.storage.scores.count else {
            return nil
        }

        let score = self.storage.scores[row]
        var cellIdentifier = ""
        var text = ""

        if tableColumn == tableView.tableColumns[1]
        {
            cellIdentifier = CellIdentifiers.IDCell
            text = score.name
        }
        else if tableColumn == tableView.tableColumns[2]
        {
            cellIdentifier = CellIdentifiers.PointsCell
            text = "\(score.score)"
        }
        else if tableColumn == tableView.tableColumns[0]
        {
            cellIdentifier = CellIdentifiers.RangCell
            text = "\(row+1)"
        }

        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView
        {
            cell.textField?.stringValue = text
            return cell
        }

        return nil
    }
}
