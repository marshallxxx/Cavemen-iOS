//
//  JobdetailsViewController.swift
//  Cavemen
//
//  Created by Evghenii Nicolaev on 11/29/15.
//  Copyright © 2015 Endava. All rights reserved.
//

import UIKit
import SDWebImage

class JobdetailsViewController: UIViewController, JobDetailsViewControllerProtocol {

    var jobName:String?
    var jobConfig:JobConfig?
    
    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var buildSuccess: UILabel!
    @IBOutlet weak var buildWarning: UILabel!
    @IBOutlet weak var buildError: UILabel!
    
    @IBOutlet weak var buildSuccessSwitch: UISwitch!
    @IBOutlet weak var buildWarningSwitch: UISwitch!
    @IBOutlet weak var buildErrorSwitch: UISwitch!
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var showMoreButton: UIButton!
    
    @IBOutlet weak var jobHealthImageView: UIImageView!
    
    @IBOutlet weak var buildNrLabel: UILabel!
    @IBOutlet weak var InQueueIV: UIImageView!
    @IBOutlet weak var colorBackgroudView: UIView!
    
    @IBAction func saveConfigForJob(sender: AnyObject) {
        
        let loadingVC = LoadingViewController.getInstanceOfLoadingViewController()
        self.presentViewController(loadingVC, animated: false, completion: nil)
        
        jobConfig!.jobName = jobName!
        jobConfig!.device = SettingsManager.pushToken
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).networkManager!.postJobConfig(jobConfig!.serialize(), job: jobName!) { (jsonResponse) -> () in
            
            loadingVC.dismissViewControllerAnimated(false, completion: nil)
            
            if jsonResponse != nil {
                print("%@", jsonResponse)
            }
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        jobNameLabel.text = jobName
        
        buildSuccessSwitch.setOn(jobConfig!.notifyOk, animated: false)
        buildWarningSwitch.setOn(jobConfig!.notifyWarning, animated: false)
        buildErrorSwitch.setOn(jobConfig!.notifyFail, animated: false)
        
        buildSuccessSwitch.addTarget(self, action: "buidSuccesssSwitchChange", forControlEvents: .ValueChanged)
        buildWarningSwitch.addTarget(self, action: "buidWarningSwitchChange", forControlEvents: .ValueChanged)
        buildErrorSwitch.addTarget(self, action: "buidErrorSwitchChange", forControlEvents: .ValueChanged)
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).networkManager!.getJobInfo(jobName!) { (resultJSON) -> () in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let json = resultJSON {
                    
                    if let healthIcon = json["healthReport"][0]["iconUrl"].string {
                        self.jobHealthImageView.sd_setImageWithURL(NSURL(string: healthURL.stringByAppendingString(healthIcon)))
                    }
                    
                    self.buildNrLabel.text = "\(json["builds"].count)"
                    
                    var image = UIImage(named: "queueCircle")
                    image = image?.imageWithRenderingMode(.AlwaysTemplate)
                    
                    self.InQueueIV.tintColor = UIColor.redColor()
                    
                    if let inQueue = json["inQueue"].bool {
                        if inQueue {
                            self.InQueueIV.tintColor = UIColor.greenColor()
                        }
                    }
                    
                    self.InQueueIV.image = image
                    
                    if let color = json["color"].string {
                        switch color {
                        case "red":
                            self.colorBackgroudView.backgroundColor = UIColor.redColor()
                        case "blue":
                            self.colorBackgroudView.backgroundColor = UIColor.blueColor()
                        case "yellow":
                            self.colorBackgroudView.backgroundColor = UIColor.yellowColor()
                        default:
                            self.colorBackgroudView.backgroundColor = UIColor.darkGrayColor()
                        }
                    }
                    
                }
            })
        }
        
    }
    
    func buidSuccesssSwitchChange() {
        jobConfig!.notifyOk = buildSuccessSwitch.on
    }
    
    func buidWarningSwitchChange() {
        jobConfig!.notifyWarning = buildWarningSwitch.on
    }
    
    func buidErrorSwitchChange() {
        jobConfig!.notifyFail = buildErrorSwitch.on
    }
    
    @IBAction func StartButtonPressed(sender: AnyObject) {
        
        let loadingVC = LoadingViewController.getInstanceOfLoadingViewController()
        self.presentViewController(loadingVC, animated: false, completion: nil)
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).networkManager!.postJobCommand(jobName!) { (result) -> () in
            
            loadingVC.dismissViewControllerAnimated(false, completion: nil)
            
            let alert = UIAlertController(title: "Warning!", message: "Failed to start job", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))

            if result != nil && result == "success" {
                alert.title = "Success"
                alert.message = nil
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(200 * NSEC_PER_MSEC)), dispatch_get_main_queue()) { () -> Void in
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }
        
    }

    
}
