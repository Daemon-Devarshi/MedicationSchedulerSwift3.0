//
//  PatientTests.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 8/22/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import XCTest
import CoreData
@testable import Medication

class PatientTests: XCTestCase {
    var managedObjectContext: NSManagedObjectContext?
    let email = "barnard@gmail.com"
    let fullName = "Christiaan Barnard"
    let phoneNumer = "2343622343"
    
    //MARK:- Overriden functions
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        if managedObjectContext == nil {
            managedObjectContext = setUpInMemoryManagedObjectContext()
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK:- fileprivate functions
    fileprivate func getNurse() -> Nurse {
        // create nurse
        let nurseEmail = "clara@gmail.com"
        let nursePassword = "clara"
        
        let nurseEntity = Nurse.entity()
        let nurse = Nurse(entity: nurseEntity, insertInto: managedObjectContext!)
        nurse.email = nurseEmail
        nurse.password = nursePassword
        
        return nurse
    }
    
    
    //MARK:- Testing functions defined in Patient.swift
    // testing for true condition: class func isDuplicate(email email: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Bool
    func testIsDuplicate() {
        // get nurse
        let nurse = getNurse()
        
        // create patient without error
        let error = Patient.addPatient(withEmail: email, fullName: fullName, phoneNumber: phoneNumer, nurse: nurse, inManagedObjectContext: managedObjectContext!)
        XCTAssertNil(error, "New patient should be crated without an error")
        
        // check for duplicate
        let isDuplicate = Patient.isDuplicate(email: email, nurse: nurse, inManagedObjectContext: managedObjectContext!)
        XCTAssertTrue(isDuplicate, "Duplicate patient should be identified by his/her email")
    }
    
    // testing for false condition: class func isDuplicate(email email: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Bool
    func testIsNotDuplicate() {
        // get nurse
        let nurse = getNurse()
        
        // check for duplicate
        let isDuplicate = Patient.isDuplicate(email: email, nurse: nurse, inManagedObjectContext: managedObjectContext!)
        XCTAssertFalse(isDuplicate, "Record does not exist in local db, hence it should not be duplicate")
    }
    
    
    // testing for error condition: class func addPatient(withEmail email: String, fullName: String, phoneNumber: String, nurse: Nurse,inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSError?
    func testAddPatientError() {
        // get nurse
        let nurse = getNurse()
        
        // create patient
        let error = Patient.addPatient(withEmail: email, fullName: fullName, phoneNumber: phoneNumer, nurse: nurse, inManagedObjectContext: managedObjectContext!)
        XCTAssertNil(error, "New patient should be crated without an error")
    }
    
    // testing for success condition: class func addPatient(withEmail email: String, fullName: String, phoneNumber: String, nurse: Nurse,inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSError?
    func testAddPatient() {
        // get nurse
        let nurse = getNurse()
        
        // create patient without error
        var error = Patient.addPatient(withEmail: email, fullName: fullName, phoneNumber: phoneNumer, nurse: nurse, inManagedObjectContext: managedObjectContext!)
        XCTAssertNil(error, "New patient should be crated without an error")
        
        // create patient with error
        error = Patient.addPatient(withEmail: email, fullName: fullName, phoneNumber: phoneNumer, nurse: nurse, inManagedObjectContext: managedObjectContext!)
        XCTAssertNotNil(error, "Duplicate patient not allowed")
    }
}
