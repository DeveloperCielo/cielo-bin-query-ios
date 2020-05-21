//
//  Environment.swift
//  BinQuery
//
//  Created by Jeferson Nazario on 14/05/20.
//  Copyright © 2020 jnazario.com. All rights reserved.
//

public enum Environment: String {
    case sandbox
    case production
}

extension Environment: Codable {
    public init(from decoder: Decoder) throws {
        self = try Environment(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .production
    }
}
