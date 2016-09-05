//
//  MedicationTests.swift
//  MedicationTests
//
//  Created by Devarshi Kulshreshtha on 8/20/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import XCTest
import CoreData
@testable import Medication

class MedicationTests: XCTestCase {
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
    
    //MARK:- Private functions
    private func getPatient() -> Patient {
        // create nurse
        let nurseEmail = "clara@gmail.com"
        let nursePassword = "clara"
        
        let nurseEntity = Nurse.entity()
        let nurse = Nurse(entity: nurseEntity, insertInto: managedObjectContext!)
        nurse.email = nurseEmail
        nurse.password = nursePassword
        
        // Create patient
        let email = "edward@gmail.com"
        let fullName = "Edward Jenner"
        let phoneNumer = "8989236784"
        
        let patientEntity = Patient.entity()
        let patient = Patient(entity: patientEntity, insertInto: managedObjectContext!)
        patient.email = email
        patient.fullName = fullName
        patient.phoneNumber = phoneNumer
        patient.nurse = nurse
        
        return patient
    }
    
    //MARK:- Testing functions defined in Medication.swift
    // testing for true condition : func isEmpty() -> Bool
    func testIsEmpty() {
        // Get patient
        let patient = getPatient()
        
        // create medication
        let medication = Medication.createMedication(withPatient: patient, inManagedObjectContext: managedObjectContext!)
        XCTAssertNotNil(medication, "Medication created should never be nil")
        
        // check for empty
        let isEmpty = medication.isEmpty()
        
        XCTAssertTrue(isEmpty, "Empty medication should return true")
    }
    
    // testing for false condition : func isEmpty() -> Bool
    func testIsNotEmpty(){
        // Get patient
        let patient = getPatient()
        
        // create medication
        let medication = Medication.createMedication(withPatient: patient, inManagedObjectContext: managedObjectContext!)
        XCTAssertNotNil(medication, "Medication created should never be nil")
        
        // assigning values to medication before isEmpty check
        medication.dosage = 24
        medication.scheduleTime = Date()
        
        // CreateMedicine
        let medicineEntity = Medicine.entity()
        let medicine = Medicine(entity: medicineEntity, insertInto: managedObjectContext!)
        medicine.name = "Asprin"
        
        medication.medicine = medicine
        
        // check for empty
        let isEmpty = medication.isEmpty()
        
        XCTAssertFalse(isEmpty, "Non-empty medication should return false")
    }
    
    // testing: class func createMedication(withPatient patient:Patient, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Medication
    func testCreateMedication() {
        // Get patient
        let patient = getPatient()
        
        // create medication
        let medication = Medication.createMedication(withPatient: patient, inManagedObjectContext: managedObjectContext!)
        XCTAssertNotNil(medication, "Medication created should never be nil")
    }
}
