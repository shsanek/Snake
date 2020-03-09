//
//  UserIDController.swift
//  2KeyboardsGame
//
//  Created by Павел Бабинцев on 09/03/2019.
//  Copyright © 2019 Павел Бабинцев. All rights reserved.
//

import Cocoa

internal final class UserIDController: NSObject, NSTextFieldDelegate
{
    internal var successHandler: (() -> Void)?
    internal var wrongUserHanlder: (() -> Void)?
    
    private let userValidator: IUserValidator
    
    internal init(validator: IUserValidator)
    {
        self.userValidator = validator
        super.init()
    }
    
    private weak var input: NSTextField?
    
    internal func setTextFiled(_ input: NSTextField)
    {
        self.input = input
        self.input?.delegate = self
    }
    
    internal func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool
    {
        if (commandSelector == #selector(NSResponder.insertNewline(_:)))
        {
            if textView.string.count > 0
            {
                self.validate(textView.string)
                return true
            }
            else
            {
                return false
            }
            
        }
        else if (commandSelector == #selector(NSResponder.cancelOperation(_:)))
        {
            return true
        }
        return false
    }
    
    private func validate(_ user: String)
    {
        if self.userValidator.validUser(user)
        {
            self.successHandler?()
        }
        else
        {
            self.wrongUserHanlder?()
        }
    }
    
}
