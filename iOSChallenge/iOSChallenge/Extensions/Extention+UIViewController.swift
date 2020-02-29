//
//  Extention+UIViewController.swift
//  iOSChallenge
//
//  Created by Oniel Rosario on 2/28/20.
//  Copyright © 2020 Oniel Rosario. All rights reserved.
//

import UIKit


fileprivate var aView: UIView?

extension UIViewController {
   func showSpinner() {
    aView = UIView(frame: self.view.bounds)
    aView!.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    let spinner = UIActivityIndicatorView(style: .large)
    spinner.center = aView!.center
    spinner.startAnimating()
    aView!.addSubview(spinner)
    self.view.addSubview(aView!)
    }
    
    func removeSpinner() {
        aView?.removeFromSuperview()
    }
}
