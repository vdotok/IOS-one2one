//
//  CheckUsernameRepsonse.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 08/06/2021.
//

import Foundation

struct CheckUserNameResponse: Codable {
    let message: String
    let processTime, status: Int

    enum CodingKeys: String, CodingKey {
        case message
        case processTime = "process_time"
        case status
    }
}
