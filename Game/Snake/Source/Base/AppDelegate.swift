//
//  AppDelegate.swift
//  Snake
//
//  Created by Шипин Александр on 05/02/2020.
//  Copyright © 2020 CFT. All rights reserved.
//


import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    private var retains = [Any]()
    private var game = GameServer()
    
    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)


		let windowPlayer1:NSWindowController = storyboard.instantiateController(withIdentifier: "GameWindow") as! NSWindowController
		let windowPlayer2:NSWindowController = storyboard.instantiateController(withIdentifier: "GameWindow") as! NSWindowController
		
        self.retains.append(windowPlayer1)
        self.retains.append(windowPlayer2)
        windowPlayer1.showWindow(self)
        windowPlayer2.showWindow(self)

        windowPlayer1.window!.title = "player 1"
        windowPlayer2.window!.title = "player 2"

        let vc1 = windowPlayer1.contentViewController! as! ViewController
        let vc2 = windowPlayer2.contentViewController! as! ViewController

        vc1.setGameController(self.game)
        vc2.setGameController(self.game)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
}
