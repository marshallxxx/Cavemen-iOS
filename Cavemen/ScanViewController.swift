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
    @IBOutlet var reader: ZBarReaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reader.readerDelegate = self
        reader.torchMode = 0
        reader.trackingColor = UIColor.blueColor()
        reader.zoom = 0.2
        let scanner: ZBarImageScanner = reader.scanner
        scanner.setSymbology(ZBAR_I25, config: ZBAR_CFG_ENABLE, to: 0)
        reader.start()
    }
    
    func readerView(readerView: ZBarReaderView!, didReadSymbols symbols: ZBarSymbolSet!, fromImage image: UIImage!) {
        for symbol in symbols {
            let resultString = NSString(string: symbol.data) as String
            print(resultString)
            NSUserDefaults.standardUserDefaults().setValue(resultString, forKey: "result")
        }
        readerView.hidden = true
        self.performSelector("dismissViewController", withObject: self, afterDelay: 0.5)
        
    }
    
    
    func dismissViewController() {
        self .dismissViewControllerAnimated(true, completion: {})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}





