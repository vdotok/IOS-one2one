//
//  AllUsersService.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 09/06/2021.
//  Copyright © 2021 VDOTOK. All rights reserved.
//

import Foundation

typealias AllUserComplition = ((Result<AllUsersResponse, Error>) -> Void)

protocol AllUserStoreAble {
    func fetchUsers(with request: AllUserRequest, complition: @escaping AllUserComplition)
}

class AllUsersService:BaseDataStore, AllUserStoreAble {
    
    let translator: ObjectTranslator
    
    init(service: Service, translator: ObjectTranslator = ObjectTranslation()) {
        self.translator = translator
        super.init(service: service)
    }
    
    
    func fetchUsers(with request: AllUserRequest, complition: @escaping AllUserComplition) {
        service.post(request: request) {[weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.translate(data: data, complition: complition)
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
    private func translate(data: Data, complition: AllUserComplition) {
        do {
           
            let response: AllUsersResponse = try translator.decodeObject(data: data)
            complition(.success(response))
        }
        catch {
            complition(.failure(error))
        }
    }
    
}
