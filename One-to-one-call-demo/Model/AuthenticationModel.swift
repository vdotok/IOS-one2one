//
//  AuthenticationModel.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 21/09/2022.
//  Copyright © 2022 VDOTOK. All rights reserved.
//

import Foundation
import UIKit

struct AuthenticationModel: Codable {
    let projectId: String
    let tenantApiUrl: String
    let apiKey, tenantName: String
    
    enum CodingKeys: String, CodingKey {
        case projectId = "project_id"
        case tenantApiUrl = "tenant_api_url"
        case apiKey = "api_key"
        case tenantName = "tenant_name"
    }
}
