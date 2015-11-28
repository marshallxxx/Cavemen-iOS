//
//  JobTableViewCell.swift
//  Cavemen
//
//  Created by Evghenii Nicolaev on 11/28/15.
//  Copyright © 2015 Endava. All rights reserved.
//

import UIKit

class JobTableViewCell: UITableViewCell {

    var jobName:String?
    
    func updateCellDetails() {
        textLabel?.text = jobName
    }
    
}
