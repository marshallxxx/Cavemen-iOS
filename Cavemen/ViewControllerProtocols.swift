//
//  ViewControllerProtocols.swift
//  Cavemen
//
//  Created by Evghenii Nicolaev on 11/28/15.
//  Copyright © 2015 Endava. All rights reserved.
//

import Foundation

protocol JobsViewControllerProtocol: class {
    var project:Project? { get set }
    var jobModels:[JobModel]? {get set}
}

protocol ScanViewControllerProtocol: class {
    func didScannedQRCode(code: NSString)
}

protocol JobDetailsViewControllerProtocol: class {
    var jobName:String? {get set}
    var jobConfig:JobConfig? { get set }
}

protocol JobMoreInfoViewControllerProtocol: class {
    var jobName:String? {get set}
}
