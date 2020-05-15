//
//  AccessToken.swift
//  CieloOAuth
//
//  Created by Jeferson Nazario on 27/02/20.
//  Copyright © 2020 jnazario.com. All rights reserved.
//

import Foundation

@objc public class AccessToken: NSObject, Decodable {
    public var token: String
    var expiresIn: String
    var issuedAt: Date
    
    init(token: String, expiresIn: String, issuedAt: Date) {
        self.token = token
        self.expiresIn = expiresIn
        self.issuedAt = issuedAt
    }
    
    func stillValid() -> Bool {
//        var issMs = issuedAt.time
//        var nowMs = Calendar.getInstance().time.time
//        var expMs = (issMs + expiresIn * 1000)
//
//        return nowMs in issMs until expMs
        
        return false
    }
}
