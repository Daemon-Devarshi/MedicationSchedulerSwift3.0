//
//  AddNewBaseViewController.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 8/20/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//


import UIKit
import CoreData

// Base class for all the forms implemented using static UITableView
class FormBaseViewController: UITableViewController {
    //MARK: Enum Declaration
    private enum MaxCharsLimitFieldTag : Int {
        case email = 101
        case password = 102
        case fullName = 103
        case phoneNumber = 104
        case name = 105
        
        var maxCharsLimit: Int {
            switch self {
            case .email:
                return 250
            case .password:
                return 30
            case .fullName:
                return 150
            case .phoneNumber:
                return 30
            case .name:
                return 250
            }
        }
    }
    
    //MARK: var declarations
    lazy var managedObjectContext : NSManagedObjectContext! =  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    //MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignTapGesture()
    }
    
    //MARK:- TextField delegates
    /*
     Implementing logic to handle max characters restriction on UITextField at one place 😇 ie. in super class.
     */
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // Check if text field's tag is MaxCharsLimitFieldTag
        if let maxCharsLimitField = MaxCharsLimitFieldTag(rawValue: textField.tag), let text = textField.text {
            let nsString = text as NSString
            let newString = nsString.replacingCharacters(in: range, with: string)
            // restrict characters greater than maxCharsLimit
            if newString.length > maxCharsLimitField.maxCharsLimit {
                return false
            }
            else {
                return true
            }
        }
        else {
            return true
        }
    }
}

//MARK:- Keyboard dismiss related methods
extension FormBaseViewController {
    private func assignTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FormBaseViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
    }
    
    func hideKeyboard() {
        tableView.endEditing(true)
    }
}
