//
//  LoginService.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 08/06/2021.
//

import Foundation

typealias loginComplition = ((Result<UserResponse, Error>) -> Void)


protocol LoginStoreable {
    func login(with request: LoginRequest, complition: @escaping loginComplition)
}

class LoginService: BaseDataStore, LoginStoreable {
    
    let translator: ObjectTranslator
    
    init(service: Service, translator: ObjectTranslator = ObjectTranslation()) {
        self.translator = translator
        super.init(service: service)
    }
    
    func login(with request: LoginRequest, complition: @escaping loginComplition) {
        service.post(request: request) { (result) in
            switch result {
            case .success(let data):
                self.translate(data: data, complition: complition)
            case .failure(let error):
                complition(.failure(error))
                
            }
        }
    }
    
    private func translate(data: Data, complition: loginComplition) {
        do {
            let response: UserResponse = try translator.decodeObject(data: data)
            switch response.status {
            case 200:
                VDOTOKObject<UserResponse>().setData(response)
                VDOTOKObject<String>().setToken(response.authToken)
            default:
                break
            }
            complition(.success(response))

        }
        catch {
            complition(.failure(error))
        }
    }
}
