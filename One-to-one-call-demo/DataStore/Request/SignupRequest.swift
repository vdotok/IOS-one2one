//
//  SignupRequest.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 08/06/2021.
//

import Foundation

struct SignupRequest: Codable, APIRequest {
    func getMethod() -> RequestType {
        .POST
    }
    
    func getPath() -> String {
        return "SignUp"
    }
    
    let fullName: String
    let email, password: String
    let projectID: String = AuthenticationConstants.PROJECTID
    let deviceType: String = "ios"
    let deviceModel: String = "iPhone 8"
    let deviceOSVer: String = "13.3"
    let appVersion: String = "1.1.5 (269)"
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case email, password
        case projectID = "project_id"
        case deviceType = "device_type"
        case deviceModel = "device_model"
        case deviceOSVer = "device_os_ver"
        case appVersion = "app_version"
    }
    
    
}
