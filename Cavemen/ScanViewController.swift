//
//  ScanViewController.swift
//  ZBarSwift
//
//  Created by Cristina Savciuc on 11/26/15.
//  Copyright © 2015 Cristina Savciuc. All rights reserved.
//

import UIKit

extension ZBarSymbolSet: SequenceType {
    public func generate() -> NSFastGenerator {
        return NSFastGenerator(self)
    }
}

class ScanViewController: UIViewController, UITextFieldDelegate, ZBarReaderViewDelegate {
    
    weak var scanDelegate:ScanViewControllerProtocol?
    @IBOutlet var reader: ZBarReaderView!
    
    var cameraLayer:CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reader.readerDelegate = self
        reader.torchMode = 0
        reader.zoom = 1
        reader.trackingColor = UIColor.blueColor()
        let scanner: ZBarImageScanner = reader.scanner
        scanner.setSymbology(ZBAR_I25, config: ZBAR_CFG_ENABLE, to: 0)
        reader.start()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        addCameraOverlay()
    }
    
    func readerView(readerView: ZBarReaderView!, didReadSymbols symbols: ZBarSymbolSet!, fromImage image: UIImage!) {
        var resultString:String?
        for symbol in symbols {
            resultString = NSString(string: symbol.data) as String
        }

        reader.stop()
        
        weak var weakself = self
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            if let delegate = self.scanDelegate {
                delegate.didScannedQRCode(resultString ?? "")
            }
            weakself?.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func dismissViewController() {
        self .dismissViewControllerAnimated(true, completion: {})
        reader.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addCameraOverlay() {
        let path = UIBezierPath(rect: reader.frame)
        let square = reader.bounds.width * 0.8
        let rect = CGRect(x: reader.frame.origin.x+(reader.bounds.width*0.1),
            y: reader.frame.origin.y + ((reader.bounds.height - square)/2),
            width: square,
            height: square)

        let cameraHole = UIBezierPath(rect: rect)
        path.appendPath(cameraHole)
        path.usesEvenOddFillRule = true
        
        cameraLayer = CAShapeLayer()
        cameraLayer!.path = path.CGPath;
        cameraLayer!.fillRule = kCAFillRuleEvenOdd;
        cameraLayer!.fillColor = UIColor.blackColor().CGColor;
        cameraLayer!.opacity = 0.75;
        
        self.view.layer.addSublayer(cameraLayer!)
        
    }

    @IBAction func CancelButtonPress(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
}





