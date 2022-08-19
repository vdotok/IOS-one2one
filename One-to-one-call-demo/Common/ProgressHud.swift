//
//  ProgressHud.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 08/06/2021.
//  Copyright © 2021 VDOTOK. All rights reserved.
//

import Foundation
import UIKit
import KRProgressHUD

class ProgressHud {
    
    static func showError(message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func alertForPermission(message: String,viewController: UIViewController) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Settings", style: .cancel) { (alert) -> Void in
            if let appSettings = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) {
                if UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings)
                }
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
        }
        
        
    }
    
    static func show(viewController: UIViewController) {
        KRProgressHUD.show()
    }
    
    static func hide() {
        KRProgressHUD.dismiss()
    }
}
