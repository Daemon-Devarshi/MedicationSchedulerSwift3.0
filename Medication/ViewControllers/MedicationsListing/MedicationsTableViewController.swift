//
//  MedicationsTableViewController.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 8/21/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import UIKit
import CoreData

class MedicationsTableViewController: UITableViewController {

    //MARK: Constants declarations
    static let embedSegueIdentifier = "EmbedMedicationsTableViewController"
    
    //MARK: Var declarations
    fileprivate var managedObjectContext: NSManagedObjectContext!
    var patient: Patient! {
        didSet {
            managedObjectContext = patient.managedObjectContext
        }
    }
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Medication> = {
        // initialize fetch request
        let fetchRequest = NSFetchRequest<Medication>()
        
        // Add entity
        let medicationEntity = Medication.entity()
        fetchRequest.entity = medicationEntity
        
        // initialize predicate
        let predicate = NSPredicate(format: "patient = %@",self.patient)
        fetchRequest.predicate = predicate
        fetchRequest.includesPendingChanges = false
        
        // adding sort descriptors
        let sortDescriptor = NSSortDescriptor(key:Medication.scheduleTimeKey, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // initializing fetch results controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    
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
}

// MARK: - Table view data source & delegates
extension MedicationsTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let fetchedObjectsCount = fetchedResultsController.fetchedObjects?.count, fetchedObjectsCount > 0 else {
            return NoMedicationInfoTableViewCell.cellHeight
        }
        
        return MedicationInfoTableViewCell.cellHeight
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
            return tableView.dequeueReusableCell(withIdentifier: NoMedicationInfoTableViewCell.cellIdentifier, for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MedicationInfoTableViewCell.cellIdentifier, for: indexPath) as! MedicationInfoTableViewCell
        
        // populate Table View Cell
        let medication = fetchedResultsController.object(at: indexPath)
        cell.populate(withMedicationInfo: medication)
        
        return cell
    }
}
