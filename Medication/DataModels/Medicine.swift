//
//  Medicine.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 8/20/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import Foundation
import CoreData

class Medicine: NSManagedObject {
    static let nameKey = "name"
    
    //MARK:- Class functions
    // check for duplicate nurse record
    class func isDuplicate(name: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Bool {
        var isDuplicate = true
        
        let fetchRequest = NSFetchRequest<Medicine>(entityName: "Medicine")
        
        // [c] added for case-insensitive comparison
        let predicate = NSPredicate(format: "name = [c]%@",name)
        fetchRequest.predicate = predicate
        
        
        do {
            let duplicateCount = try managedObjectContext.count(for: fetchRequest)
            if duplicateCount == 0 {
                // insert nurse since it is unique
                isDuplicate = false
            }
            else {
                // is duplicate
            }
        } catch {
            let error = error as NSError
            print("\(error), \(error.userInfo)")
        }
        
        return isDuplicate
    }
    
    // add a medicine
    class func addMedicine(name: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSError? {
        var insertError : NSError? = nil
        
        // Check if it is a duplicate entry
        if isDuplicate(name: name, inManagedObjectContext: managedObjectContext) {
            // is duplicate
            let userInfo = [NSLocalizedDescriptionKey :  NSLocalizedString("Duplicate Medicine!", value: "Medicine with same name already exists.", comment: "")]
            insertError = NSError(domain: CoreDataCustomErrorCodes.duplicateRecord.domain, code: CoreDataCustomErrorCodes.duplicateRecord.rawValue, userInfo: userInfo)
        }
        else {
            // name does not exist 😊
            let medicineEntity = Medicine.entity()
            let newMedicine = Medicine(entity: medicineEntity, insertInto: managedObjectContext)
            newMedicine.name = name
            
            do {
                try managedObjectContext.save()
            } catch {
                let error = error as NSError
                print("\(error), \(error.userInfo)")
                insertError = error
            }
        }
        
        return insertError
    }
    
}
