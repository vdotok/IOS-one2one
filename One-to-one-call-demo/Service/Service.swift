//
//  Service.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 08/06/2021.
//  Copyright © 2021 VDOTOK. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case noData
    case requestEncodingError(error: Error)
}

extension ServiceError: LocalizedError {
    public var errorDescription: String? {
        return NSLocalizedString(
            "Project id or tenant url not found.",
            comment: "Resource Not Found"
        )
    }
}

protocol Request {
    var urlRequest: URLRequest { get }
}

/// An abstract service type that can have multiple implementation for example - a NetworkService that gets a resource from the Network or a DiskService that gets a resource from Disk
protocol Service {
    func get(request: APIRequest, completion: @escaping (Result<Data, Error>) -> Void)
    func post(request: APIRequest, completion: @escaping (Result<Data,Error>) -> Void)
}

/// A concrete implementation of Service class responsible for getting a Network resource
final class NetworkService: Service {
    func get(request: APIRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        print("API: \(request.getPath())")
        let request = request.request()
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(ServiceError.noData))
                return
            }
            completion(.success(data))
        }.resume()
    }
    
    func post(request: APIRequest, completion: @escaping (Result<Data,Error>) -> Void) {
        print("API: \(request.getPath())")
        print("Sending Params: \(String(describing: String(data: request.getBody() ?? Data(), encoding: .utf8)))")
        let request = request.request()
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            guard let data = data else {
                
                completion(.failure(ServiceError.noData))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
