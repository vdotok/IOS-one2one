//
//  AllUserRequest.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 09/06/2021.
//  Copyright © 2021 VDOTOK. All rights reserved.
//

import Foundation

struct AllUserRequest: APIRequest {
    func getMethod() -> RequestType {
        .POST
    }
    
    func getPath() -> String {
        "AllUsers"
    }
    func getBody() -> Data? {
        return nil
    }
    
    
}
