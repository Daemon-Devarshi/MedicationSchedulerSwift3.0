//
//  Medication.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 8/20/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import Foundation
import CoreData

// enum declarations
enum PriorityMode: Int, CustomStringConvertible {
    case high = 1
    case medium = 5
    case low = 9
    
    var description: String {
        switch self {
        case .high:
            return "High"
        case .medium:
            return "Medium"
        case .low:
            return "Low"
        }
    }
}

enum Units: Int, CustomStringConvertible {
    case pills = 1
    case ml = 2
    
    var description: String {
        switch self {
        case .pills:
            return "pills"
        case .ml:
            return "ml"
        }
    }
}

class Medication: NSManagedObject {
    
    
    static let scheduleTimeKey = "scheduleTime"
    
    
    
    var priorityMode: PriorityMode {
        return PriorityMode(rawValue: Int(priority!))!
    }
    
    //MARK: functons
    // Check for blank fields
    func isEmpty() -> Bool {
        var isEmpty = true
        
        // Other attributes are not checked because those have valid default values
        if let _ = medicine, let _dosage = dosage, let _ = scheduleTime, Int(_dosage) > 0 {
            isEmpty = false
        }
        
        return isEmpty
    }
    
    
    //MARK: Class methods
    class func createMedication(withPatient patient:Patient, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Medication {
        let medicationEntity = Medication.entity()
        let medication = Medication(entity: medicationEntity, insertInto: managedObjectContext)
        medication.patient = patient
        return medication
    }

}
