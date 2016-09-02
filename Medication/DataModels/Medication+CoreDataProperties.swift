//
//  Medication+CoreDataProperties.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 9/2/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Medication {

    @NSManaged var dosage: NSNumber?
    @NSManaged var unit: NSNumber?
    @NSManaged var priority: NSNumber?
    @NSManaged var scheduleTime: Date?
    @NSManaged var medicine: Medicine?
    @NSManaged var patient: Patient?

}
