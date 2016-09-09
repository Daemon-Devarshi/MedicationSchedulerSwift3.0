//
//  Nurse+CoreDataProperties.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 9/9/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import Foundation
import CoreData

extension Nurse {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Nurse> {
        return NSFetchRequest<Nurse>(entityName: "Nurse");
    }

    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var patient: NSSet?

}

// MARK: Generated accessors for patient
extension Nurse {

    @objc(addPatientObject:)
    @NSManaged public func addToPatient(_ value: Patient)

    @objc(removePatientObject:)
    @NSManaged public func removeFromPatient(_ value: Patient)

    @objc(addPatient:)
    @NSManaged public func addToPatient(_ values: NSSet)

    @objc(removePatient:)
    @NSManaged public func removeFromPatient(_ values: NSSet)

}
