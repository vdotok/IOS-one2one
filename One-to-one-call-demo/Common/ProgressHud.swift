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
   static let shared: ProgressHud = ProgressHud()
    private init() {}
    
    let windowScene = UIApplication.shared
        .windows[0].windowScene
    var popupWindow: UIWindow?
    let viewController = UIViewController()
    
    static func showError(message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
     func alertForPermission(message: String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: UIAlertController.Style.alert)
        
         alert.addAction(UIAlertAction(title: "Cancel", style: .default) {  [weak self]_ in
             guard let self = self else {return}
             self.popupWindow = nil
         })
        alert.addAction(UIAlertAction(title: "Settings", style: .cancel) { [weak self] (alert) -> Void in
            guard let self = self else {return}
            if let appSettings = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) {
                if UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings)
                }
            }
            self.popupWindow = nil
        })
         if let windowScene = windowScene  {
             popupWindow = UIWindow(windowScene: windowScene)
             popupWindow?.frame = UIScreen.main.bounds
             popupWindow?.backgroundColor = .clear
             popupWindow?.windowLevel = UIWindow.Level.statusBar + 1
             popupWindow?.rootViewController = self.viewController
             popupWindow?.makeKeyAndVisible()
             popupWindow?.rootViewController?.present(alert, animated: true)
         }
        
    }
    
    static func show(viewController: UIViewController) {
        KRProgressHUD.show()
    }
    
    static func hide() {
        KRProgressHUD.dismiss()
    }
}
