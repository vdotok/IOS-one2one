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
    static let TENANTSERVER = UserDefaults.baseUrl
    static let PROJECTID = UserDefaults.projectId
}

class Common {
    static public func isAuthorized(with complition: ((Bool) -> ()))  {
        if AVCaptureDevice.authorizationStatus(for: .audio) != .authorized {
            complition(false)
            return
        } else if AVCaptureDevice.authorizationStatus(for: .video) != .authorized {
        complition(false)
            return
        }
        complition(true)
        return
    }
}
