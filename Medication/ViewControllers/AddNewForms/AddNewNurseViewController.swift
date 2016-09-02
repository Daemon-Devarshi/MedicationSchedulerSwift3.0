//
//  AddNewNurseViewController.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 8/20/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import UIKit
import CoreData

class AddNewNurseViewController: FormBaseViewController {
    
    //MARK: Outlets declarations
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    
    //MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK:- User actions
extension AddNewNurseViewController{
    
    @IBAction func addNurse(_ sender: AnyObject) {
        // validations
        
        // blank fields validation
        guard let email = emailField.text, let password = passwordField.text, let confirmPassword = confirmPasswordField.text, email.length > 0 && password.length > 0 && confirmPassword.length > 0 else {
            displaySingleButtonActionAlert(withTitle: "Error!", message: "Please enter both Email and Password.")
            return
        }
        
        // email validation
        guard email.isEmail else {
            displaySingleButtonActionAlert(withTitle: "Error!", message: "Please enter valid Email.")
            return
        }
        
        // password mismatch validation
        guard password == confirmPassword else {
            displaySingleButtonActionAlert(withTitle: "Error!", message: "Entered passwords do not match.")
            return
        }
        
        // insert new nurse
        if let error = Nurse.addNurse(withEmail: email, password: password, inManagedObjectContext: managedObjectContext) {
            displaySingleButtonActionAlert(withTitle: "Nurse could not be added!", message: error.localizedDescription)
            return
        }
        else {
            displaySingleButtonActionAlert(withTitle: "Success!", message: "Nurse successfully added.") {[weak self] in
                // weak used to break retain cycle
                guard let _self = self else {
                    return
                }
                
                // navigate back to login screen once a nurse is successfully added
                _ = _self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
