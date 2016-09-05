//
//  LoginViewController.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 8/20/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: FormBaseViewController{
    
    //MARK: Outlets declarations
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    //MARK: Overriden methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.emptyAllInputFields()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // To dismiss keyboard when next view controller is pushed
        tableView.endEditing(true)
        
        if let segueIdentifier = segue.identifier {
            if segueIdentifier == PatientsTableViewController.pushSegueIdentifier {
                // passing managedObjectContext to PatientsTableViewController
                let patientsTableViewController = segue.destination as! PatientsTableViewController
                patientsTableViewController.managedObjectContext = managedObjectContext
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                patientsTableViewController.loggedInNurse = appDelegate.loggedInNurse
            }
        }
    }
    
    //MARK:- Internal / Private methods
    func emptyAllInputFields() {
        emailField.text = ""
        passwordField.text = ""
    }
}

//MARK:- Authentication related methods
extension LoginViewController {
    @IBAction func userLogin(_ sender: AnyObject) {
        
        guard let email = emailField.text, let password = passwordField.text, email.length > 0 && password.length > 0 else {
            displaySingleButtonActionAlert(withTitle: "Error!", message: "Please enter both Email and Password.")
            return
        }
        
        guard email.isEmail else {
            displaySingleButtonActionAlert(withTitle: "Error!", message: "Please enter valid Email.")
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.loggedInNurse = authenticatedNurse(withEmail: email, password: password)
        
        if let _ = appDelegate.loggedInNurse {
            performSegue(withIdentifier: PatientsTableViewController.pushSegueIdentifier, sender: self)
        }
        else {
            displaySingleButtonActionAlert(withTitle: "Invalid User!", message: "Please enter correct Email and Password.")
        }
    }
    
    func authenticatedNurse(withEmail email: String, password: String) -> Nurse? {
        var nurse: Nurse?
        
        guard email.length > 0 && password.length > 0 && email.isEmail else {
            return nil
        }
        
        if let _nurse = Nurse.getNurse(withEmail: email, password: password, inManagedObjectContext: managedObjectContext) {
            nurse = _nurse
        }
        
        return nurse
    }
}


