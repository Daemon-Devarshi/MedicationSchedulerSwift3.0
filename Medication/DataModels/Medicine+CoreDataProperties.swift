//
//  Medicine+CoreDataProperties.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 9/9/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import Foundation
import CoreData

extension Medicine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medicine> {
        return NSFetchRequest<Medicine>(entityName: "Medicine");
    }

    @NSManaged public var name: String?
    @NSManaged public var medication: NSSet?

}

// MARK: Generated accessors for medication
extension Medicine {

    @objc(addMedicationObject:)
    @NSManaged public func addToMedication(_ value: Medication)

    @objc(removeMedicationObject:)
    @NSManaged public func removeFromMedication(_ value: Medication)

    @objc(addMedication:)
    @NSManaged public func addToMedication(_ values: NSSet)

    @objc(removeMedication:)
    @NSManaged public func removeFromMedication(_ values: NSSet)

}
