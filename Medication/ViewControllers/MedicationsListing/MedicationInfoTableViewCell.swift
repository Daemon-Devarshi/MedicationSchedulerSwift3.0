//
//  MedicationInfoTableViewCell.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 8/21/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import UIKit

// Cell to display when patients are unavailable
class NoMedicationInfoTableViewCell: UITableViewCell {
    static let cellIdentifier = "NoMedicationInfoTableViewCell"
    static let cellHeight: CGFloat = 100
}

// Cell to display data
class MedicationInfoTableViewCell: UITableViewCell {
    //MARK: Outlet declarations
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var scheduleTime: UILabel!
    @IBOutlet weak var dosage: UILabel!
    @IBOutlet weak var priority: UILabel!
    
    //MARK: constant declarations
    static let cellIdentifier = "MedicationInfoTableViewCell"
    static let cellHeight: CGFloat = 78
    
    //MARK: functions
    func populate(withMedicationInfo medication: Medication){
        name.text = medication.medicine!.name
        scheduleTime.text = medication.scheduleTime!.displayTime()
        let unit = Units(rawValue: Int(medication.unit!))!.description
        dosage.text = "\(medication.dosage!.int32Value) \(unit)"
        priority.text = "\(medication.priorityMode.description)"
    }
}
