//
//  CieloBinQueryResponse.swift
//  BinQuery
//
//  Created by Jeferson Nazario on 14/05/20.
//  Copyright © 2020 jnazario.com. All rights reserved.
//

@objc public class CieloBinQueryResponse: NSObject, Codable {
    public var status: String
    public var provider: String
    public var cardType: String
    public var foreignCard: Bool
    public var corporateCard: Bool
    public var issuer: String
    public var issuerCode: String
    public var prePaid: Bool
}
