//
//  Utils.swift
//  2KeyboardsGame
//
//  Created by Павел Бабинцев on 23/05/2019.
//  Copyright © 2019 Павел Бабинцев. All rights reserved.
//

import Foundation
import Cocoa


final public class FileLoader
{
    public enum Folder: String
    {
        case Desktop = "Desktop"
    }
    
    public static func load<T: Decodable>(filename: String, folder: Folder = .Desktop) -> T?
    {
        let url = FileLoader.filePath(filename: filename, folder: folder)
        guard let data = try? Data(contentsOf: url) else { return nil }
        if let value = try? JSONDecoder().decode(T.self, from: data)
        {
            return value
        }
        return nil
    }
    
    public static func saveData<T: Encodable>(_ data: T, filename: String, folder: Folder = .Desktop)
    {
        guard let tempData = try? JSONEncoder().encode(data) else { return }
        let url = FileLoader.filePath(filename: filename, folder: folder)
        try? tempData.write(to: url)
    }
    
    private static func filePath(filename: String, folder: Folder) -> URL
    {
        let home = FileManager.default.homeDirectoryForCurrentUser
        let filePathUrl = home.appendingPathComponent(folder.rawValue, isDirectory: true).appendingPathComponent(filename)
        
        return filePathUrl
    }
    
}

public class AlertController
{
    public static func showAlert(string: String)
    {
        let alert = NSAlert()
        alert.messageText = string
        alert.alertStyle = .critical
        alert.runModal()
    }
}

public final class WeakRef<T>
{
    public var value: T? {
        return self.weakValue as? T
    }
    private weak var weakValue: AnyObject?

    public init(_ value: T)
    {
        self.weakValue = value as AnyObject
    }
}
