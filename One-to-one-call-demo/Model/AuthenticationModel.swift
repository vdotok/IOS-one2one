//
//  AuthenticateModel.swift
//  Chat-Demo-IOS
//
//  Created by Fajar Chishtee on 24/02/2023.
//  Copyright © 2023 VDOTOK. All rights reserved.
//

import Foundation
import Foundation
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
