//
//  VDOTOKObject.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 08/06/2021.
//  Copyright © 2021 VDOTOK. All rights reserved.
//

import Foundation
fileprivate let userDefaults = UserDefaults.standard
fileprivate let authToken = "authToken"
struct VDOTOKObject<T: Codable> {
    
    func setData(_ data: T, for key: String? = nil) {
        let objectkey = key ?? String(describing: T.self)
        do {
            let encoded = try JSONEncoder().encode(data)
            userDefaults.set(encoded, forKey: objectkey)
            userDefaults.synchronize()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getData(for key: String? = nil) -> T? {
        let objectKey = key ?? String(describing: T.self)
        do {
            if let data = userDefaults.data(forKey: objectKey) {
                let decode = try JSONDecoder().decode(T.self, from: data)
                return decode
            }
            return nil
        }
        catch {
            return nil
        }
    }
    
    
    func setToken(_ token: String?) {
        guard let token = token else { return }
        userDefaults.setValue(token, forKeyPath: authToken)
        userDefaults.synchronize()
    }
    
    func getToken() -> String? {
        return userDefaults.string(forKey: authToken)
    }

}
