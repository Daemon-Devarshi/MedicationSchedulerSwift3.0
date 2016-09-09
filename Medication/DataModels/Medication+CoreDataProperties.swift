//
//  Medication+CoreDataProperties.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 9/9/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import Foundation
import CoreData 

extension Medication {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medication> {
        return NSFetchRequest<Medication>(entityName: "Medication");
    }

    @NSManaged public var dosage: NSNumber?
    @NSManaged public var priority: NSNumber?
    @NSManaged public var scheduleTime: NSDate?
    @NSManaged public var unit: NSNumber?
    @NSManaged public var medicine: Medicine?
    @NSManaged public var patient: Patient?

}
