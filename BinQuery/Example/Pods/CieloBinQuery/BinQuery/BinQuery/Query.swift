//
//  Query.swift
//  BinQuery
//
//  Created by Jeferson Nazario on 14/05/20.
//  Copyright © 2020 jnazario.com. All rights reserved.
//

import Foundation
import CieloOAuth

@objc public protocol CieloBinQueryProtocol {
    func query(bin: String, completion: @escaping (CieloBinQueryResponse?, String?) -> Void)
}

@objc public class Query: NSObject, CieloBinQueryProtocol {
    private let environment: Environment
    private let clientId: String?
    private let clientSecret: String?
    private let accessToken: String?
    private let merchantId: String?
    
    private let authenticateErrorMessage: String = "Não foi possível autenticar."
    private let queryErrorMessage: String = "Não foi possível consultar este cartão."
    
    private var credentialClient: HttpCredentialsClient?
    
    init(merchantId: String?, clientId: String? = nil, clientSecret: String? = nil, environment: Environment = .production, accessToken: String? = nil) {
        self.environment = environment
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.accessToken = accessToken
        self.merchantId = merchantId
        
        var oAuthEnv = CieloOAuth.Environment.production
        if environment == .sandbox {
            oAuthEnv = CieloOAuth.Environment.sandbox
        }
        
        if let hasId = clientId, let hasSecret = clientSecret {
            credentialClient = HttpCredentialsClient(clientId: hasId,
                                                     clientSecret: hasSecret,
                                                     environment: oAuthEnv)
        }
    }
    
    public static func instance(merchantId: String,
                                clientId: String,
                                clientSecret: String,
                                environment: Environment = .production) -> Query {
        return Query(merchantId: merchantId, clientId: clientId, clientSecret: clientSecret, environment: environment)
    }
    
    public static func instance(merchantId: String,
                                clientId: String,
                                token: String,
                                environment: Environment = .production) -> Query {
        return Query(merchantId: merchantId, clientId: clientId, environment: environment, accessToken: token)
    }
    
    private func authenticate(completion: @escaping (String?, String?) -> Void) {
        credentialClient?.getOAuthCredentials {[weak self] (accessToken, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let token = accessToken else {
                completion(nil, self?.authenticateErrorMessage)
                return
            }
            
            completion(token.token, nil)
        }
    }
    
    private func cardBin(bin: String, accessToken: String, completion: @escaping (CieloBinQueryResponse?, String?) -> Void) {
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        let session: URLSession = URLSession(configuration: config)
        
        var envUrl = "apiquery"
        if environment == .sandbox {
            envUrl = "apiquerysandbox"
        }
        
        guard let url = URL(string: "https://\(envUrl).cieloecommerce.cielo.com.br/1/cardBin/\(bin)") else {
            completion(nil, "Não foi possível conectar ao servidor, verifique os parâmetros e tente novamente.")
            return
        }
        
        var request = URLRequest(url: url)
        if let merchant = merchantId {
            request.allHTTPHeaderFields = ["Authorization": "Bearer \(accessToken)", "merchantId": merchant]
        }
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (result, _, error) in
            
            #if DEBUG
            debugPrint("Result:\n\(String(data: result ?? Data(), encoding: .utf8) ?? "sem result")")
            #endif
            
            guard error == nil else {
                completion(nil, error?.localizedDescription)
                return
            }
            guard let data = result else {
                completion(nil, "Erro ao processar operação.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                let decodableData = try decoder.decode(CieloBinQueryResponse.self, from: data)
                
                debugPrint(decodableData)
                
                DispatchQueue.main.async {
                    completion(decodableData, nil)
                }
            } catch let exception {
                debugPrint("Exception: \(exception)")
                completion(nil, exception.localizedDescription)
            }
        })
        
        task.resume()
    }
    
    /// Método para realizar a consulta.
    /// \nParâmetros:
    /// \n - bin: 6 primeiros digitos do cartão
    /// \n - accessToken: Token de acesso gerado na autenticação
    public func query(bin: String, completion: @escaping (CieloBinQueryResponse?, String?) -> Void) {
        guard accessToken == nil else {
            self.goQuery(bin: bin, accessToken: accessToken!, completion: completion)
            return
        }
        
        authenticate {[weak self] (accessToken, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let token = accessToken else {
                completion(nil, self?.authenticateErrorMessage)
                return
            }
            
            self?.goQuery(bin: bin, accessToken: token, completion: completion)
        }
    }
    
    private func goQuery(bin: String, accessToken: String, completion: @escaping (CieloBinQueryResponse?, String?) -> Void) {
        cardBin(bin: bin, accessToken: accessToken, completion: {[unowned self] (response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let queryResponse = response else {
                completion(nil, self.queryErrorMessage)
                return
            }
            
            completion(queryResponse, nil)
        })
    }
}
