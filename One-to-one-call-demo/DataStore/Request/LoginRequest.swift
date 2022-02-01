//
//  LoginRequest.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 08/06/2021.
//  Copyright © 2021 VDOTOK. All rights reserved.
//

import Foundation

struct LoginRequest: Codable, APIRequest {
    func getMethod() -> RequestType {
        .POST
    }
    
    func getPath() -> String {
        "Login"
    }
    
    func getBody() -> Data? {
        do {
           return try JSONEncoder().encode(self)
        }
        catch {
            return Data()
        }
    }
    
    let email: String
    let password: String
    var project_id: String = AuthenticationConstants.PROJECTID
}
