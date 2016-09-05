//
//  PatientDetailViewController.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 8/20/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import UIKit
import CoreData

class PatientDetailViewController: UIViewController {
    //MARK: Constants declarations
    static let pushSegueIdentifier = "PushPatientDetailViewController"
    
    //MARK: Var declarations
    private var managedObjectContext: NSManagedObjectContext!
    private var medicationsTableViewController: MedicationsTableViewController!
    var patient: Patient! {
        didSet {
            managedObjectContext = patient.managedObjectContext
        }
    }
    
    //MARK: Outlets declarations
    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var patientEmail: UILabel!
    @IBOutlet weak var patientPhoneNumber: UILabel!
    
    
    //MARK: Overriden methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populate()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let segueIdentifier = segue.identifier {
            if segueIdentifier == MedicationsTableViewController.embedSegueIdentifier {
                // passing managedObjectContext to PatientsTableViewController
                medicationsTableViewController = segue.destination as! MedicationsTableViewController
                medicationsTableViewController.patient = patient
            }
            else if segueIdentifier == AddNewMedicationViewController.pushSegueIdentifier {
                // passing managedObjectContext to PatientsTableViewController
                let addNewMedicationViewController = segue.destination as! AddNewMedicationViewController
                addNewMedicationViewController.patient = patient
            }
        }
    }
    
    private func populate() {
        patientName.text = patient.fullName
        patientEmail.text = patient.email
        patientPhoneNumber.text = patient.phoneNumber
    }
}
