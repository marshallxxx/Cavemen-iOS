//
//  ProjectTableViewCell.swift
//  Cavemen
//
//  Created by Evghenii Nicolaev on 11/28/15.
//  Copyright © 2015 Endava. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    var projectName:String?
    
    func updateCellDetails() {
        textLabel?.text = projectName
    }

}
