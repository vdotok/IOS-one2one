//
//  AuthenticationService.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 08/06/2021.
//  Copyright © 2021 VDOTOK. All rights reserved.
//

import Foundation

struct AuthenticateResponse: Codable {
    let mediaServerMap: ServerMap
    let message: String
    let messagingServerMap: ServerMap
    let processTime, status: Int

    enum CodingKeys: String, CodingKey {
        case mediaServerMap = "media_server_map"
        case message
        case messagingServerMap = "messaging_server_map"
        case processTime = "process_time"
        case status
    }
}

// MARK: - ServerMap
struct ServerMap: Codable {
    let completeAddress: String
    let endPoint: String?
    let host, port, serverMapProtocol: String

    enum CodingKeys: String, CodingKey {
        case completeAddress = "complete_address"
        case endPoint = "end_point"
        case host, port
        case serverMapProtocol = "protocol"
    }
}

typealias AuthenticateCompletionHandler = (Result<AuthenticateResponse, Error>) -> Void


protocol AuthenticateStoreable  {
    func fetch(with request: AuthenticateRequest,complitionHandler: @escaping AuthenticateCompletionHandler)
}

class AuthenticateService: BaseDataStore, AuthenticateStoreable {
    

    let translation: ObjectTranslator
    init(service: Service, translation: ObjectTranslator = ObjectTranslation()) {
        self.translation = translation
        super.init(service: service)
    }
    
    func fetch(with request: AuthenticateRequest, complitionHandler: @escaping AuthenticateCompletionHandler) {
                service.post(request: request) { (result) in
                    switch result {
                    case .failure(let error):
                        print("error")
                    case .success(let data ):
                        self.translate(data: data, complition: complitionHandler)
        
                    }
                }
    }
    
        private func translate(data: Data, complition: AuthenticateCompletionHandler) {
            do {
                let response: AuthenticateResponse = try translation.decodeObject(data: data)
                VDOTOKObject<AuthenticateResponse>().setData(response)
                complition(.success(response))
            } catch let error{
                complition(.failure(error))
    
            }
    
        }
    
    
}
