//
//  AddNewPatientViewController.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 8/20/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import UIKit

class AddNewPatientViewController: FormBaseViewController {
    //MARK: Constants declarations
    static let pushSegueIdentifier = "PushAddNewPatientViewController"
    
    //MARK: Var declarations
    var loggedInNurse: Nurse!
    
    //MARK: Outlets declarations
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    
    //MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

//MARK:- User Actions
extension AddNewPatientViewController{
    
    @IBAction func addPatient(_ sender: AnyObject) {
        guard let email = emailField.text, let fullName = fullNameField.text, let phoneNumber = phoneNumberField.text, email.length > 0 && fullName.length > 0 && phoneNumber.length > 0 else {
            displaySingleButtonActionAlert(withTitle: "Error!", message: "Please enter values in all fields.")
            return
        }
        
        // email validation
        guard email.isEmail else {
            displaySingleButtonActionAlert(withTitle: "Error!", message: "Please enter valid Email.")
            return
        }
        
        // insert new nurse
        if let error = Patient.addPatient(withEmail: email, fullName: fullName, phoneNumber: phoneNumber, nurse: loggedInNurse, inManagedObjectContext: managedObjectContext) {
            displaySingleButtonActionAlert(withTitle: "Patient could not be added!", message: error.localizedDescription)
            return
        }
        else {
            displaySingleButtonActionAlert(withTitle: "Success!", message: "Patient successfully added.") {[weak self] in
                // weak used to break retain cycle
                guard let _self = self else {
                    return
                }
                _ = _self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
