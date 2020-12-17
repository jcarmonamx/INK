//
//  ActivityIndicator.swift
//  fitink
//
//  Created by Manuel on 16/12/20.
//

import UIKit
import Foundation

fileprivate var aView : UIView?

extension UIViewController {

    /*
     * Activity Indicator tutorial
     *   https://www.youtube.com/watch?v=twgb5IPwR4I
     * Otros recursos (revisar GIT)
     *   https://coderwall.com/p/su1t1a/ios-customized-activity-indicator-with-swift
     */
    
    func showActivityIndicator () {
        
        aView = UIView (frame: self.view.bounds)
        //aView?.backgroundColor = UIColor.init(red:1, green: 1, blue: 1, alpha: 0.9)
        aView?.backgroundColor = UIColor(named: "color-indicator")
        
        let ai = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        ai.center = aView!.center
        ai.color = UIColor(named: "graiink")
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
    }
    
    func hideActivityIndicator () {
        aView?.removeFromSuperview()
        aView = nil
    }
    
}

extension UIView {
    
    /*
     * Activity Indicator tutorial
     *   https://www.youtube.com/watch?v=twgb5IPwR4I
     * Otros recursos (revisar GIT)
     *   https://coderwall.com/p/su1t1a/ios-customized-activity-indicator-with-swift
     */
    
    func showActivityIndicator () {
        
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        aView = UIView (frame: window!.bounds)
        aView?.backgroundColor = UIColor.init(red:1, green: 1, blue: 1, alpha: 0.9)
        
        let ai = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        ai.center = aView!.center
        ai.color = UIColor(named: "graiink")
        ai.startAnimating()
        aView?.addSubview(ai)
        window?.addSubview(aView!)
        
    }
    
    func hideActivityIndicator () {
        aView?.removeFromSuperview()
        aView = nil
    }
}

