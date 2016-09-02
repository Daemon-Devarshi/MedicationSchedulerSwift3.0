//
//  MedicineInfoTableViewCell.swift
//  Medication
//
//  Created by Devarshi Kulshreshtha on 8/21/16.
//  Copyright © 2016 Devarshi. All rights reserved.
//

import UIKit

// Cell to display when patients are unavailable
class NoMedicineInfoTableViewCell: UITableViewCell {
    static let cellIdentifier = "NoMedicineInfoTableViewCell"
    static let cellHeight : CGFloat = 100
}

// Cell to display data
class MedicineInfoTableViewCell: UITableViewCell {
    static let cellIdentifier = "MedicineInfoTableViewCell"
    static let cellHeight : CGFloat = 50
    
    @IBOutlet weak var medicineName: UILabel!
    
     func populate(withMedicineInfo medicine: Medicine){
        medicineName.text = medicine.name
    }
}
