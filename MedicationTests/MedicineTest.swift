//
//  MedicineTest.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 8/22/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import XCTest
import CoreData
@testable import Medication

class MedicineTest: XCTestCase {
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
    
    //MARK:- Testing functions defined in Medicine.swift
    // testing for false condition: class func isDuplicate(name name: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Bool
    func testIsNotDuplicate() {
        let name = "Lipitor"
        let isDuplicate = Medicine.isDuplicate(name: name, inManagedObjectContext: managedObjectContext!)
        XCTAssertFalse(isDuplicate, "If medicine does not exist in local db, duplicate medicine check should fail")
    }
    
    // testing for true condition: class func isDuplicate(name name: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Bool
    func testIsDuplicate() {
        let name = "Nexium"
        
        // Adding medicine
        let error = Medicine.addMedicine(name: name, inManagedObjectContext: managedObjectContext!)
        XCTAssertNil(error, "There should not be any error while adding a medicine")
        
        // verifying duplicacy with case-insesitive check
        let isDuplicate = Medicine.isDuplicate(name: "NEXIUM", inManagedObjectContext: managedObjectContext!)
        XCTAssertTrue(isDuplicate, "Duplicate medicine should be identified with case-insensitive check")
    }
    
    // testing for error condition: class func addMedicine(name name: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSError?
    func testAddMedicineError() {
        let name = "Vicodin"
        
        // Adding medicine
        var error = Medicine.addMedicine(name: name, inManagedObjectContext: managedObjectContext!)
        XCTAssertNil(error, "There should not be any error while adding a medicine")
        
        // Re-adding same medicine
        error = Medicine.addMedicine(name: name.uppercased(), inManagedObjectContext: managedObjectContext!)
        XCTAssertNotNil(error, "Medicine with duplicate name should not be added")
    }
    
    // testing for no error condition: class func addMedicine(name name: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSError?
    func testAddMedicine() {
        let name = "Zipsor"
        
        // Adding medicine
        let error = Medicine.addMedicine(name: name, inManagedObjectContext: managedObjectContext!)
        XCTAssertNil(error, "There should not be any error while adding a medicine")
    }
}
