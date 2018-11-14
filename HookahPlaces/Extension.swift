//
//  Extension.swift
//  HookahPlaces
//
//  Created by Евгений on 05/11/2018.
//  Copyright © 2018 Momotov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func configBackBarButtonItem() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.black
    }
    
    func addLineToView(view: UIView, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lineView)
        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views))
    }
    
    func showDefaultAlertController(title: String?, message: String?, handler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.view.tintColor = UIColor.black
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            handler?()
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    class func displaySpinner(onView: UIView) -> UIView {
        let spinnerView = UIView(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activeIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activeIndicator.startAnimating()
        activeIndicator.center = spinnerView.center
        DispatchQueue.main.async {
            spinnerView.addSubview(activeIndicator)
            onView.addSubview(spinnerView)
        }
        return spinnerView
    }
    
    class func removeSpinner(spinner: UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    
}
