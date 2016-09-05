//
//  PatientsTableViewController.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 8/20/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import UIKit
import CoreData

class PatientsTableViewController: UITableViewController {
    //MARK: Var declarations
    var managedObjectContext: NSManagedObjectContext!
    var loggedInNurse: Nurse!
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Patient> = {
        // initialize fetch request
        let fetchRequest = NSFetchRequest<Patient>(entityName: String(Patient.self))
        
        // initialize predicate
        let predicate = NSPredicate(format: "nurse = %@",self.loggedInNurse)
        fetchRequest.predicate = predicate
        
        // adding sort descriptors
        let sortDescriptor = NSSortDescriptor(key:Patient.fullNameKey, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // initializing fetch results controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    
    //MARK: Constants declarations
    static let pushSegueIdentifier = "PushPatientsTableViewController"
    
    //MARK: Overriden methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // removing blank cells
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // fetching data
        do {
            try self.fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
            //TODO: Handle error gracefully
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // To dismiss keyboard when next view controller is pushed
        tableView.endEditing(true)
        
        if let segueIdentifier = segue.identifier {
            if segueIdentifier == AddNewPatientViewController.pushSegueIdentifier {
                // passing managedObjectContext to PatientsTableViewController
                let addNewPatientViewController = segue.destination as! AddNewPatientViewController
                addNewPatientViewController.loggedInNurse = loggedInNurse
            }
            else if segueIdentifier == PatientDetailViewController.pushSegueIdentifier {
                let patientDetailViewController = segue.destination as! PatientDetailViewController
                patientDetailViewController.patient = fetchedResultsController.object(at: tableView.indexPathForSelectedRow!)
            }
        }
    }
}

// MARK: - Table view data source & delegates
extension PatientsTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let fetchedObjectsCount = fetchedResultsController.fetchedObjects?.count , fetchedObjectsCount > 0 else {
            return NoPatientTableViewCell.cellHeight
        }
        
        return PatientInfoTableViewCell.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            let numberOfObjects = sectionInfo.numberOfObjects
            if numberOfObjects == 0 {
                return 1
            }
            else {
                return numberOfObjects
            }
            
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let fetchedObjectsCount = fetchedResultsController.fetchedObjects?.count, fetchedObjectsCount > 0 else {
            return tableView.dequeueReusableCell(withIdentifier: NoPatientTableViewCell.cellIdentifier, for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PatientInfoTableViewCell.cellIdentifier, for: indexPath) as! PatientInfoTableViewCell
        
        // populate Table View Cell
        let patient = fetchedResultsController.object(at: indexPath) 
        cell.populate(withPatientInfo: patient)
        
        return cell
    }
}
