//
//  Patient+CoreDataProperties.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 8/21/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Patient {

    @NSManaged var email: String?
    @NSManaged var fullName: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var medication: NSSet?
    @NSManaged var nurse: Nurse?

}
