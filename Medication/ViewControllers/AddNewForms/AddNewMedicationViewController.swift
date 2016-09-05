//
//  AddNewMedicationViewController.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 8/20/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import UIKit
import CoreData
import EventKit

class AddNewMedicationViewController: FormBaseViewController {
    
    //MARK: Constants declarations
    static let pushSegueIdentifier = "PushAddNewMedicationViewController"
    
    //MARK: Var declarations
    
    // Pickers
    private var timePicker: UIDatePicker!
    private var unitPicker: UIPickerView!
    private var priorityPicker: UIPickerView!
    
    // Values displayed in pickers
    private var pirorityModes: [PriorityMode] = [.high, .medium, .low]
    private var units: [Units] = [.pills, .ml]
    
    private var eventStore: EKEventStore?
    
    private var selectedMedicine: Medicine?
    private var selectedPriority: PriorityMode?
    private var selectedUnit: Units?
    private var scheduleTime: Date?
    
    var patient: Patient! {
        didSet {
            managedObjectContext = patient.managedObjectContext
        }
    }
    
    //MARK: Outlets declarations
    @IBOutlet weak var medicineField: UITextField!
    @IBOutlet weak var scheduleMedicationField: UITextField!
    @IBOutlet weak var dosageField: UITextField!
    @IBOutlet weak var selectUnitField: UITextField!
    @IBOutlet weak var selectPriorityField: UITextField!
    
    //MARK: Overriden methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDatePicker()
        configurePickerViews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let segueIdentifier = segue.identifier {
            if segueIdentifier == MedicinesTableViewController.pushSegueIdentifier {
                // passing managedObjectContext to PatientsTableViewController
                let medicinesTableViewController = segue.destination as! MedicinesTableViewController
                medicinesTableViewController.managedObjectContext = managedObjectContext
                medicinesTableViewController.medicineSelectionHandler = { [weak self](selectedMedicine) in
                    // weak used to break retain cycle
                    guard let _self = self else {
                        return
                    }
                    
                    _self.medicineField.text = selectedMedicine.name
                    _self.selectedMedicine = selectedMedicine
                }
            }
        }
    }
}

//MARK:- Implementing UIPickerViewDataSource, UIPickerViewDelegate protocols
extension AddNewMedicationViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == unitPicker {
            return units.count
        }
        else if pickerView == priorityPicker{
            return pirorityModes.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title: String?
        
        if pickerView == unitPicker {
            title = units[row].description
        }
        else if pickerView == priorityPicker{
            title = pirorityModes[row].description
        }
        
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == unitPicker {
            let value = units[row]
            selectedUnit = value
            selectUnitField.text = value.description
        }
        else if pickerView == priorityPicker {
            let value = pirorityModes[row]
            selectedPriority = value
            selectPriorityField.text = value.description
        }
    }
}

//MARK:- Utility methods
extension AddNewMedicationViewController {
    // Scheduling reminders
    private func scheduleReminder() {
        if let eventStore = eventStore {
            let reminder = EKReminder(eventStore: eventStore)
            let notes = "\(selectedMedicine!.name!) \(dosageField.text!) \(selectedUnit!.description)"
            
            reminder.title = "Provide \(notes) to \(patient.fullName!)"
            reminder.notes = notes
            reminder.calendar = eventStore.defaultCalendarForNewReminders()
            let alarm = EKAlarm(absoluteDate: scheduleTime!)
            reminder.addAlarm(alarm)
            reminder.priority = selectedPriority!.rawValue
            let recurrenceRule = EKRecurrenceRule(recurrenceWith: .daily, interval: 1, end: nil)
            reminder.recurrenceRules = [recurrenceRule]
            
            // setting dueDateComponents for recurring events
            let gregorian = NSCalendar(identifier:NSCalendar.Identifier.gregorian)
            let dailyComponents = gregorian?.components([.year, .month, .day, .hour, .minute, .second, .timeZone], from: scheduleTime!)
            reminder.dueDateComponents = dailyComponents
            
            do {
                try eventStore.save(reminder, commit: true)
                displaySingleButtonActionAlert(withTitle: "Success!", message: "Medication successfully scheduled.") {[weak self] in
                    // weak used to break retain cycle
                    guard let _self = self else {
                        return
                    }
                    _ = _self.navigationController?.popViewController(animated: true)
                }
            } catch {
                let error = error as NSError
                print("\(error), \(error.userInfo)")
                displaySingleButtonActionAlert(withTitle: "Error!", message: error.localizedDescription)
            }
        }
        
    }
    
    // Configuring date picker
    private func configureDatePicker() {
        timePicker = UIDatePicker(frame: CGRect.zero)
        timePicker.datePickerMode = .time
        timePicker.backgroundColor = UIColor.white
        timePicker.addTarget(self, action: #selector(AddNewMedicationViewController.medicationScheduleChanged), for: .valueChanged)
        scheduleMedicationField.inputView = timePicker
    }
    
    // Configuring all picker views
    private func configurePickerViews() {
        // configuring unitPicker
        unitPicker = UIPickerView()
        unitPicker.delegate = self
        unitPicker.dataSource = self
        selectUnitField.inputView = unitPicker
        
        // configuring priorityPicker
        priorityPicker = UIPickerView()
        priorityPicker.delegate = self
        priorityPicker.dataSource = self
        selectPriorityField.inputView = priorityPicker
        
    }
}

//MARK:- User actions and text field delegate
extension AddNewMedicationViewController {
    override func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // to disable text editing on fields which have input view associated with them
        if textField == scheduleMedicationField || textField == selectPriorityField || textField == selectUnitField {
            return false
        }
        return true
    }
    
    func medicationScheduleChanged(_ sender:UIDatePicker) {
        scheduleTime = sender.date.fullMinuteTime()
        scheduleMedicationField.text = scheduleTime!.displayTime()
    }
    
    @IBAction func scheduleMedication(_ sender: AnyObject) {
        // validations
        guard let dosage = dosageField.text else {
            displaySingleButtonActionAlert(withTitle: "Error!", message: "Please enter all details.")
            return
        }
        
        guard let selectedMedicine = selectedMedicine, let selectedPriority = selectedPriority, let selectedUnit = selectedUnit, let scheduleTime = scheduleTime  else {
            displaySingleButtonActionAlert(withTitle: "Error!", message: "Please enter all details.")
            return
        }
        
        // Create medication and assign values to its attributes
        let medication = Medication.createMedication(withPatient: patient, inManagedObjectContext: managedObjectContext)
        medication.dosage = NSNumber(value: Int32(dosage)!)
        medication.unit = NSNumber(value: Int32(selectedUnit.rawValue))
        medication.priority = NSNumber(value: Int32(selectedPriority.rawValue))
        medication.scheduleTime = scheduleTime
        medication.medicine = selectedMedicine
        medication.patient = patient
    
        // saving in local db + creating reminder
        do {
            try managedObjectContext.save()
            
            //  scheduling the reminder
            if eventStore == nil {
                eventStore = EKEventStore()
                eventStore!.requestAccess(
                    to: .reminder, completion: {[weak self](granted, error) in
                        guard let _self = self else {
                            return
                        }
                        // Background to main thread
                        DispatchQueue.main.async(execute: { 
                            if !granted {
                                print("Access to store not granted")
                                print(error!.localizedDescription)
                                _self.displaySingleButtonActionAlert(withTitle: "Permission Declined!", message: "Reminder could not be scheduled.")
                            } else {
                                print("Access granted")
                                _self.scheduleReminder()
                            }
                        })
                })
            }
            else {
                scheduleReminder()
            }
        } catch {
            let error = error as NSError
            print("\(error), \(error.userInfo)")
            displaySingleButtonActionAlert(withTitle: "Error!", message: error.localizedDescription)
        }
        
        
    }
}
