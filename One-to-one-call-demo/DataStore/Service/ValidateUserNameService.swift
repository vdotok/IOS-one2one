//
//  ValidateUserNameService.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 08/06/2021.
//  Copyright © 2021 VDOTOK. All rights reserved.
//

import Foundation
typealias UserNameValidationComplition = ((Result<CheckUserNameResponse, Error>) -> Void)

protocol CheckUserNameStorable {
    func check(user request: ValidateUserNameRequest,  complitionHandler: @escaping UserNameValidationComplition)
}

class ValidateUserNameService: BaseDataStore, CheckUserNameStorable {
    
    let translator: ObjectTranslator
    
    init(service: Service, translator: ObjectTranslator = ObjectTranslation()) {
        self.translator = translator
        super.init(service: service)
    }
    
    func check(user request: ValidateUserNameRequest, complitionHandler: @escaping UserNameValidationComplition) {
        service.post(request: request) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                print(data)
                self.translate(data: data, complitionHandler: complitionHandler)
            case .failure(let error):
                print(error)
            
            }
        }
    }
    
    private func translate(data: Data, complitionHandler:UserNameValidationComplition ) {
        do {
            let response: CheckUserNameResponse = try translator.decodeObject(data: data)
            complitionHandler(.success(response))
        }
        catch {
            complitionHandler(.failure(error))
        }
    }
    
}
