//
//  Nurse.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 8/20/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataCustomErrorCodes: Int {
    case duplicateRecord = 801

    var domain:String {
        switch self {
        case .duplicateRecord:
            return "Duplicate Data"
        }
    }
}

class Nurse: NSManagedObject {
    //MARK:- Class functions
    // check for duplicate nurse record
    class func isDuplicate(email: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Bool {
        var isDuplicate = true
        
        let fetchRequest = NSFetchRequest<Nurse>(entityName: String(self))
        let predicate = NSPredicate(format: "email = %@",email)
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
    
    // adding nurse to local db
    class func addNurse(withEmail email: String, password: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSError? {
        var insertError : NSError? = nil
        
        // Check if it is a duplicate entry
        if isDuplicate(email: email, inManagedObjectContext: managedObjectContext) {
            // is duplicate
            let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey :  NSLocalizedString("Duplicate Nurse!", value: "Nurse with same email already exists.", comment: "")]
            insertError = NSError(domain: CoreDataCustomErrorCodes.duplicateRecord.domain, code: CoreDataCustomErrorCodes.duplicateRecord.rawValue, userInfo: userInfo)
        }
        else {
            // email does not exist 😊
            let nurseEntity = Nurse.entity()
            let newNurse = Nurse(entity: nurseEntity, insertInto: managedObjectContext)
            newNurse.email = email
            newNurse.password = password
            
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
    
    // retrieve nurse
    class func getNurse(withEmail email: String, password: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Nurse? {
        var nurse: Nurse?
        
        let fetchRequest = NSFetchRequest<Nurse>(entityName: String(self))
        let predicate = NSPredicate(format: "email = %@ AND password = %@",email, password)
        fetchRequest.predicate = predicate
        
        do {
            let returnArray = try managedObjectContext.fetch(fetchRequest)
            if returnArray.count > 0 {
                nurse = returnArray.last 
            }
        } catch let error as NSError {
            print(error)
        } catch {
            print("Unknown error")
        }
        
        return nurse
    }
}
