//
//  LoadingViewController.swift
//  Cavemen
//
//  Created by Evghenii Nicolaev on 11/28/15.
//  Copyright © 2015 Endava. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    let bgView:UIView = UIView()
    @IBOutlet weak var imageView: UIImageView!
    
    class func getInstanceOfLoadingViewController() -> LoadingViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoadingViewController") as! LoadingViewController
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        startAnimation()
        
    }
    
    func startAnimation() {
        imageView.image = UIImage(named: "cavemen1")
        imageView.animationDuration = 0.83
        imageView.animationImages = getAnimationImages()
        imageView.startAnimating()
    }
    
    func getAnimationImages() -> [UIImage] {
        
        var images = [UIImage]()
        
        for i in 2...8 {
            images.append(UIImage(named: "cavemen\(i)")!)
        }
        
        return images
    }
    
}
