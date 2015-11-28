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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reader.readerDelegate = self
        reader.torchMode = 0
        reader.trackingColor = UIColor.blueColor()
        let scanner: ZBarImageScanner = reader.scanner
        scanner.setSymbology(ZBAR_I25, config: ZBAR_CFG_ENABLE, to: 0)
        reader.start()
    }
    
    func readerView(readerView: ZBarReaderView!, didReadSymbols symbols: ZBarSymbolSet!, fromImage image: UIImage!) {
        for symbol in symbols {
            let resultString = NSString(string: symbol.data) as String
            
            if let delegate = scanDelegate {
                delegate.didScannedQRCode(resultString)
            }
        }

        reader.stop()
        
        weak var weakself = self
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
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
    
    

}





