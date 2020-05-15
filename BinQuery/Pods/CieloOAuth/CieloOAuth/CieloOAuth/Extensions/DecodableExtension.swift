//
//  DecodableExtension.swift
//  CieloOAuth
//
//  Created by Jeferson Nazario on 27/02/20.
//  Copyright © 2020 jnazario.com. All rights reserved.
//

extension JSONDecoder.KeyDecodingStrategy {
    
    static var convertFromUpperCamelCase: JSONDecoder.KeyDecodingStrategy {
        return .custom { codingKeys in
            
            let key = AnyCodingKey(codingKeys.last!)
            
            // lowercase first letter
            if let firstChar = key.stringValue.first {
                let i = key.stringValue.startIndex // swiftlint:disable:this identifier_name
                key.stringValue.replaceSubrange(
                    i ... i, with: String(firstChar).lowercased()
                )
            }
            return key
        }
    }
}

// wrapper to allow us to substitute our mapped string keys.
@objc class AnyCodingKey: NSObject, CodingKey {
    
    var stringValue: String
    var intValue: Int?
    
    convenience init(_ base: CodingKey) {
        self.init(stringValue: base.stringValue, intValue: base.intValue)
    }
    
    required init(stringValue: String) {
        self.stringValue = stringValue
    }
    
    required init(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
    
    init(stringValue: String, intValue: Int?) {
        self.stringValue = stringValue
        self.intValue = intValue
    }
}
