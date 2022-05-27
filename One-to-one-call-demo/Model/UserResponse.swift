//
//  UserResponse.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 08/06/2021.
//  Copyright © 2021 VDOTOK. All rights reserved.
//

import Foundation

struct UserResponse: Codable {
    let authToken, authorizationToken, fullName: String?
    let message: String
    let processTime: Int?
    let refID: String?
    let status, userID: Int?
    let messagingServerMap: ServerMap?
    let mediaServerMap: ServerMap?
    
    enum CodingKeys: String, CodingKey {
        case authToken = "auth_token"
        case authorizationToken = "authorization_token"
        case fullName = "full_name"
        case message
        case processTime = "process_time"
        case refID = "ref_id"
        case status
        case userID = "user_id"
        case mediaServerMap = "media_server_map"
        case messagingServerMap = "messaging_server_map"
    }
}
