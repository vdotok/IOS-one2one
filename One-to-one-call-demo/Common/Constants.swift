//
//  Constants.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 09/06/2021.
//  Copyright © 2021 VDOTOK. All rights reserved.
//


import Foundation
import AVFoundation
import UIKit

struct Constants {
    static let Request = "request"
    static let Register = "register"
}

struct AuthenticationConstants {
    static let TENANTSERVER = "q-tenant.vdotok.dev"
    static let PROJECTID = "6NE92I"
}

class Common {
    static public func isAuthorized(viewController: UIViewController) -> Bool {
        let message = "To place calls, VDOTOK needs access to your iPhone's microphone and camara. Tap Settings and turn on microphone and camera."
        if AVCaptureDevice.authorizationStatus(for: .audio) != .authorized {
            ProgressHud.alertForPermission(message: message, viewController: viewController)
            return false
        } else if AVCaptureDevice.authorizationStatus(for: .video) != .authorized {
            ProgressHud.alertForPermission(message: message, viewController: viewController)
        
            return false
        }
        return true
    }
}
