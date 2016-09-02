//
//  AddNewMedicineViewController.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 8/20/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import UIKit

class AddNewMedicineViewController: FormBaseViewController {
    //MARK: Outlets declarations
    @IBOutlet weak var nameField: UITextField!
    
    
    //MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK:- User Actions
extension AddNewMedicineViewController {
    
    @IBAction func addMedicine(_ sender: AnyObject) {
        guard let medicineName = nameField.text , medicineName.length > 0 else {
            displaySingleButtonActionAlert(withTitle: "Error!", message: "Please enter medicine name.")
            return
        }
        
        // insert new nurse
        if let error = Medicine.addMedicine(name: medicineName, inManagedObjectContext: managedObjectContext) {
            displaySingleButtonActionAlert(withTitle: "Medicine could not be added!", message: error.localizedDescription)
            return
        }
        else {
            displaySingleButtonActionAlert(withTitle: "Success!", message: "Medicine successfully added.") {[weak self] in
                // weak used to break retain cycle
                guard let _self = self else {
                    return
                }
                _ = _self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
