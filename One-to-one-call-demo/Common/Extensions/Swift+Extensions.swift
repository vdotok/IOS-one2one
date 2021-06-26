//
//  Swift+Extensions.swift
//  One-to-one-call-demo
//
//  Created by Asif Ayub on 6/24/21.
//

import Foundation


extension String {
    var isAlphanumericUnderscore: Bool {
        get {
            do {
                let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9_]*$", options: .caseInsensitive)
                return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
            } catch {
                return false
            }
        }
    }
    
    var isValidEmail: Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    var isValidEmailUsername: Bool {
        get {
            do {
                let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9_@.]*$", options: .caseInsensitive)
                return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
            } catch {
                return false
            }
        }
    }
}
