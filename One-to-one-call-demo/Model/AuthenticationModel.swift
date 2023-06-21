//
//  AuthenticationModel.swift
//  One-to-one-call-demo
//
//  Created by Fajar Chishtee on 15/06/2023.
//  Copyright © 2023 VDOTOK. All rights reserved.
//

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
