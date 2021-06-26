//
//  ApiRequest.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 08/06/2021.
//

import Foundation

public enum RequestType: String, Codable {
    case GET, POST, PUT, DELETE
    
}

protocol APIRequest: Encodable {
    func getMethod() ->     RequestType
    func getPath() ->       String
    func getBody() ->       Data?
    func getBoundary() ->   String
    func getToken() ->      (key: String, value: String)?
}

extension APIRequest {
    
    func request() -> URLRequest {
        let url = getBaseUrl()
        var request = URLRequest(url: url)
        request.httpMethod = getMethod().rawValue
        if getMethod() == .GET {
            request.httpBody = nil
        }else {
            request.httpBody = getBody()
        }
        request.addValue("Application/json", forHTTPHeaderField: "Content-Type")
        if let externalHeader = getToken() {
            request.addValue(externalHeader.value, forHTTPHeaderField: externalHeader.key)
        }
        
        return request
    }
    
    func getBody() -> Data? { try? JSONEncoder().encode(self) }
    
    func getBoundary() -> String {
        return ""
    }
    
    func getToken() -> (key: String, value: String)? {
        guard let token = VDOTOKObject<String>().getToken() else {
            return nil
        }
        return ("Authorization", "Bearer \(token)")
    }
    
    private func getBaseUrl() -> URL {
        let fakeUrl = URL(fileURLWithPath: "")
        guard let baseUrl = URL(string: CpassApi.scheme + "://" + CpassApi.host + "/" +  CpassApi.apiVersion),
              let component = URLComponents(url: baseUrl.appendingPathComponent(getPath()), resolvingAgainstBaseURL: false), var url = component.url else {
            print("Unable to create URL components")
            return fakeUrl
        }
        
        if getPath() == "AuthenticateSDK" {
            url = URL(string: "https://vtkapi.vdotok.com/API/v0/AuthenticateSDK")!
        }
        return url
    }
    
}

struct CpassApi {
    static let host = "tenant-api.vdotok.com"
    static let apiVersion = "API/v0"
    static let scheme = "https"
}
