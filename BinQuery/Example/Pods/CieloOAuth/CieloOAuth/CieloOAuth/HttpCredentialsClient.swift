//
//  HttpCredentialsClient.swift
//  CieloOAuth
//
//  Created by Jeferson Nazario on 27/02/20.
//  Copyright © 2020 jnazario.com. All rights reserved.
//

import Foundation

public protocol CredentialsClient {
//    var environment: Environment { get }
//    var clientId: String { get }
//    var clientSecret: String { get }
    func getOAuthCredentials(completion: @escaping (AccessToken?, String?) -> Void)
}

@objc public class HttpCredentialsClient: NSObject, CredentialsClient {
    public var environment: Environment
    public var clientId: String
    public var clientSecret: String
    
    public init(clientId: String, clientSecret: String, environment: Environment = .production) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.environment = environment
        
        /*
         "df66638b-3ef4-421f-a18e-e20dea38d97d",
         "q13XZ48haFg4EhAS2cjcoyX7OzRECYysY6T9TJLmKNM="
         */
    }
    
    public func getOAuthCredentials(completion: @escaping (AccessToken?, String?) -> Void) {
        let url = getUrl(for: environment)
        let api = Api.shared
        
        let credential = clientId + ":" + clientSecret
        let utf8str = credential.data(using: .utf8)
        
        guard let base64 = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) else {
            completion(nil, "Não foi possível utilizar as credenciais de acesso.")
            return
        }
        
        let params = ["credentials": base64]
        api.request(url: url, method: "POST", with: params) { (result: AuthClientModel?, error: String?) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let auth = result else {
                completion(nil, "Não foi possível realizar a autenticação")
                return
            }
            
            let accessToken = AccessToken(token: auth.accessToken, expiresIn: auth.expiresIn, issuedAt: Date())
            
            completion(accessToken, nil)
        }
    }
    
    private func getUrl(for environment: Environment) -> String {
        return environment == .production
            ? "https://cieloecommerce.cielo.com.br/api/public/v2/token/"
            : "https://meucheckoutsandbox.braspag.com.br/api/public/v2/token"
    }
}
