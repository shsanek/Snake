//
//  ViewController.swift
//  2KeyboardsGame
//
//  Created by Павел Бабинцев on 06/03/2019.
//  Copyright © 2019 Павел Бабинцев. All rights reserved.
//

import Cocoa
import AVFoundation

struct TableRecord
{
    let name: String
    let score: Int
}

class TableViewController: NSView
{

    @IBOutlet var userIdInput: NSTextField!
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var exitButton: NSButton!
    @IBOutlet var image: NSImageView!

	public var startHandler: ((_ name: String) -> Void)? = nil
 
    private let scoresStorage = ScoresStorage()
    private lazy var usersController = UsersTableController(storage: self.scoresStorage)
    private lazy var userIDController = UserIDController(validator: UserValidator(storage: self.scoresStorage))
    
    public func configure()
    {
        self.userIDController.setTextFiled(self.userIdInput)
        self.userIDController.successHandler = { [weak self] in
            self?.start()
        }
        
        self.userIDController.wrongUserHanlder = { [weak self] in
            self?.wrongUser()
        }
        self.usersController.setTableView(view: self.tableView)
    }
    
    private func resetWindow()
    {
        self.userIdInput.stringValue = ""
        self.userIdInput.becomeFirstResponder()
    }
    
    public func viewWillAppear()
    {
        let bgColor = NSColor(calibratedRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        self.userIdInput.backgroundColor = bgColor
        self.tableView.backgroundColor = bgColor
        
        let headerView = NSTableHeaderView(frame: CGRect(x: 0.0, y: 0.0, width: 120, height: 40))
        self.tableView.headerView = headerView
        for column in self.tableView.tableColumns
        {
            column.headerCell.attributedStringValue = NSAttributedString(string: column.title, attributes: [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 25)])
        }
        self.tableView.sizeLastColumnToFit()
        self.resetWindow()
    }
    
    private func wrongUser()
    {
        AlertController.showAlert(string: "Такая команда уже существует!")
    }

    public func showRecords( _ records: [TableRecord])
    {
        self.scoresStorage.update(elements: records.map {NameScore(name: $0.name, score: $0.score, mistakes: 0, combos: 0)})
    }
    
    public func doEndOfGame(points: Int, mistakes: Int, combos: Int)
    {
        
        if points <= 0
        {
            AlertController.showAlert(string: "К сожалению вы набрали 0 очков и не попадёте в рейтинг")
        }
        else
        {
            AlertController.showAlert(string: "Команда \(self.userIdInput.stringValue) зарабатывает \(points), и попадает в общий рейтинг!")

        }
       
        self.resetWindow()
    }
    
    private func start()
    {
		self.startHandler?(self.userIdInput.stringValue)
    }
    @IBAction func exitButtonTap(sender: NSButton)
    {
        exit(0)
    }
}
