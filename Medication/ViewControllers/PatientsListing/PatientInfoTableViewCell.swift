//
//  PatientInfoTableViewCell.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 8/20/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import UIKit

// Cell to display when patients are unavailable
class NoPatientTableViewCell: UITableViewCell {
    static let cellIdentifier = "NoPatientTableViewCell"
    static let cellHeight: CGFloat = 100
}

// Cell to display data
class PatientInfoTableViewCell: UITableViewCell {
    static let cellIdentifier = "PatientInfoTableViewCell"
    static let cellHeight: CGFloat = 50
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    func populate(withPatientInfo patient: Patient){
        fullNameLabel.text = patient.fullName
    }
}
