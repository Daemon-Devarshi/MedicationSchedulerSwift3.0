//
//  NurseTests.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 8/22/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import XCTest
import CoreData
@testable import Medication

class NurseTests: XCTestCase {
    var managedObjectContext: NSManagedObjectContext?

    //MARK: Overriden methods
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

    //MARK:- Testing functions defined in Nurse.swift
    // testing : class func addNurse(withEmail email: String, password: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSError?
    func testAddNurse() {
        let nurseEmail = "clara@gmail.com"
        let nursePassword = "clara"
        
        let error = Nurse.addNurse(withEmail: nurseEmail, password: nursePassword, inManagedObjectContext: managedObjectContext!)
        XCTAssertNil(error, "There should not be any error while adding a nurse")
    }
    
    // testing : class func getNurse(withEmail email: String, password: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Nurse?
    func testGetNurse() {
        // insert a nurse
        let nurseEmail = "nightingale@gmail.com"
        let nursePassword = "nightingale"
        
        let error = Nurse.addNurse(withEmail: nurseEmail, password: nursePassword, inManagedObjectContext: managedObjectContext!)
        XCTAssertNil(error, "There should not be any error while adding a nurse")
        
        // retrieve inserted nurse
        let nurse = Nurse.getNurse(withEmail: nurseEmail, password: nursePassword, inManagedObjectContext: managedObjectContext!)
        XCTAssertNotNil(nurse, "Added nurse record should be retrieved")
    }
    
    // testing for true condition: class func isDuplicate(email email: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Bool
    func testIsDuplicate() {
        // insert a nurse
        let nurseEmail = "seacole@gmail.com"
        let nursePassword = "seacole"
        
        let error = Nurse.addNurse(withEmail: nurseEmail, password: nursePassword, inManagedObjectContext: managedObjectContext!)
        XCTAssertNil(error, "There should not be any error while adding a nurse")
        
        // query to see if the new nurse email already exists
        let isDuplicate = Nurse.isDuplicate(email: nurseEmail, inManagedObjectContext: managedObjectContext!)
        
        // assert
        XCTAssertTrue(isDuplicate, "Duplicate nurse should be identified")
    }
    
    // testing for false condition: class func isDuplicate(email email: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Bool
    func testIsNotDuplicate() {
        // search for email which does not exist
        let nurseEmail = "dorothea@gmail.com"
        let isDuplicate = Nurse.isDuplicate(email: nurseEmail, inManagedObjectContext: managedObjectContext!)
        
        // assert
        XCTAssertFalse(isDuplicate, "Email queried for a nurse which does not exist in local db should return false")
    }
    
}
