//
//  MedicinesTableViewController.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 8/21/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import UIKit
import CoreData

typealias MedicineSelectionHandler = (_: Medicine) -> Void

class MedicinesTableViewController: UITableViewController {
    
    //MARK: Constants declarations
    static let pushSegueIdentifier = "PushMedicinesTableViewController"
    
    //MARK: Var declarations
    var managedObjectContext: NSManagedObjectContext!
    var medicineSelectionHandler : MedicineSelectionHandler?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Medicine> = {
        // initialize fetch request
        let fetchRequest = NSFetchRequest<Medicine>(entityName: String(Medicine.self))
        
        // adding sort descriptors
        let sortDescriptor = NSSortDescriptor(key:Medicine.nameKey, ascending: true)
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

// MARK: - Table view
extension MedicinesTableViewController {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath), let _medicineSelectionHandler = medicineSelectionHandler, cell is MedicineInfoTableViewCell{
            let medicine = fetchedResultsController.object(at: indexPath)
            _medicineSelectionHandler(medicine)
            _ = navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Table view data source
extension MedicinesTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let fetchedObjectsCount = fetchedResultsController.fetchedObjects?.count, fetchedObjectsCount > 0 else {
            return NoMedicineInfoTableViewCell.cellHeight
        }
        
        return MedicineInfoTableViewCell.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let fetchedObjectsCount = fetchedResultsController.fetchedObjects?.count, fetchedObjectsCount > 0 else {
            return tableView.dequeueReusableCell(withIdentifier: NoMedicineInfoTableViewCell.cellIdentifier, for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MedicineInfoTableViewCell.cellIdentifier, for: indexPath) as! MedicineInfoTableViewCell
        
        // populate Table View Cell
        let medicine = fetchedResultsController.object(at: indexPath) 
        cell.populate(withMedicineInfo: medicine)
        
        return cell
    }
}
