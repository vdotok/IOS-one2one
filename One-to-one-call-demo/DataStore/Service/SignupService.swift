//
//  SignupService.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 08/06/2021.
//

import Foundation

typealias SignupComplition = ((Result<UserResponse, Error>) -> Void)

protocol SignupStoreable  {
    func registerUser(with request: SignupRequest, complition: @escaping SignupComplition )
}

class SignupService: BaseDataStore, SignupStoreable {
    
    let translation: ObjectTranslator
    
    init(service: Service, translation: ObjectTranslator = ObjectTranslation()) {
        self.translation = translation
        super.init(service: service)
    }
    
    func registerUser(with request: SignupRequest, complition: @escaping SignupComplition) {
        service.post(request: request) { (response) in
            switch response {
            case .success(let data):
                self.translate(data: data, complition: complition)
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
    
    private func translate(data: Data, complition:  SignupComplition ) {
        do {
            let response: UserResponse = try translation.decodeObject(data: data)
            
            
            switch response.status {
            case 200:
                VDOTOKObject<UserResponse>().setData(response)
                VDOTOKObject<String>().setToken(response.authToken)
                
            default:
                break
            }
            complition(.success(response))
        }
        catch let error {
            complition(.failure(error))
        }
    }
    
}
