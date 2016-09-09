//
//  Patient+CoreDataProperties.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 9/9/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import Foundation
import CoreData

extension Patient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Patient> {
        return NSFetchRequest<Patient>(entityName: "Patient");
    }

    @NSManaged public var email: String?
    @NSManaged public var fullName: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var medication: NSSet?
    @NSManaged public var nurse: Nurse?

}

// MARK: Generated accessors for medication
extension Patient {

    @objc(addMedicationObject:)
    @NSManaged public func addToMedication(_ value: Medication)

    @objc(removeMedicationObject:)
    @NSManaged public func removeFromMedication(_ value: Medication)

    @objc(addMedication:)
    @NSManaged public func addToMedication(_ values: NSSet)

    @objc(removeMedication:)
    @NSManaged public func removeFromMedication(_ values: NSSet)

}
