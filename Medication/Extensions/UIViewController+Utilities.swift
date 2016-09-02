//
//  UIViewController+Utilities.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 8/20/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import UIKit
import CoreData

typealias VoidParameterReturn = (() -> Void)

extension UIViewController {
    
    // A common method to display an alert view single button and optional title, message
    func displaySingleButtonActionAlert(withTitle title: String = "", message: String = "", defaultButtonTitle: String = "OK", completion: VoidParameterReturn? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: defaultButtonTitle, style: .default) { (action:UIAlertAction!) -> Void in
            if let completion = completion {
                completion()
            }
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: { })
    }
    
    
}
