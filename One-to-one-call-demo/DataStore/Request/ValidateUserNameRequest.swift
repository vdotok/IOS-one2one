//
//  ValidateUserNameRequest.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 08/06/2021.
//

import Foundation
struct ValidateUserNameRequest: Codable, APIRequest {
    func getMethod() -> RequestType {
        .POST
    }
    
    func getPath() -> String {
       return "CheckEmail"
    }
    
    func getBody() -> Data? {
        do {
           return try JSONEncoder().encode(self)
        } catch {
            return Data()
        }
    }
    
    let email: String
    
}
