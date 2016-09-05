//
//  Patient.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 8/20/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import Foundation
import CoreData

class Patient: NSManagedObject {

    // Insert code here to add functionality to your managed object subclass
    static let fullNameKey = "fullName"
    
    //MARK:- Class functions
    // check for duplicate nurse record
    class func isDuplicate(email: String, nurse: Nurse, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Bool {
        var isDuplicate = true
        
        let fetchRequest = Patient.fetchRequest()
        // Patient with same name can be associated with a different nurse
        let predicate = NSPredicate(format: "email = %@ AND nurse = %@",email, nurse)
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
    class func addPatient(withEmail email: String, fullName: String, phoneNumber: String, nurse: Nurse, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSError? {
        var insertError : NSError? = nil
        
        // Check if it is a duplicate entry
        if isDuplicate(email: email, nurse: nurse, inManagedObjectContext: managedObjectContext) {
            // is duplicate
            let userInfo = [NSLocalizedDescriptionKey :  NSLocalizedString("Duplicate Patient!", value: "Patient with same email already exists.", comment: "")]
            insertError = NSError(domain: CoreDataCustomErrorCodes.duplicateRecord.domain, code: CoreDataCustomErrorCodes.duplicateRecord.rawValue, userInfo: userInfo)
        }
        else {
            // email does not exist 😊
            let patientEntity = Patient.entity()
            let newPatient = Patient(entity: patientEntity, insertInto: managedObjectContext)
            newPatient.email = email
            newPatient.fullName = fullName
            newPatient.phoneNumber = phoneNumber
            newPatient.nurse = nurse
            
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
