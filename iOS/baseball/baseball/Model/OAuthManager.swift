//
//  OAuthManager.swift
//  baseball
//
//  Created by Issac on 2021/05/10.
//

import Foundation
import OctoKit
import AuthenticationServices

class OAuthManager {
    let networkingCenter: ServerCommunicable
    let jsonProcessCenter: JSONDecodable
    lazy var config = OAuthConfiguration.init(token: self.getClientID(),
                                              secret: "",
                                              scopes: ["user"])
    
    init(serverCommunicable: ServerCommunicable, JSONDecodable: JSONDecodable) {
        self.networkingCenter = serverCommunicable
        self.jsonProcessCenter = JSONDecodable
    }
    
    func initPostLoginCodeWebAuthSession(completion: @escaping (Result<UserDTO, NetworkingError>) -> ()) -> ASWebAuthenticationSession? {
        let callbackUrlScheme = "baseball"
        guard let url = config.authenticate()?.appending([URLQueryItem(name: "redirect_uri", value: "baseball://")]) else { return nil }
        return ASWebAuthenticationSession.init(url: url, callbackURLScheme: callbackUrlScheme, completionHandler: { (callBack:URL?, error:Error?) in
            if error != nil {
                completion(.failure(NetworkingError.ASWebAuthenticationSessionError))
                return
            }
            guard let successURL = callBack else { return }
            let callBackURLCode = successURL.extractCallbackURLCode()
            
            self.postLoginCode(callBackURLCode: String(callBackURLCode)) { (result) in
                switch result {
                case .success(let userDTO):
                    completion(.success(userDTO))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        })
    }

    func postLoginCode(callBackURLCode: String, completion: @escaping (Result<UserDTO, NetworkingError>) -> ()) {
        networkingCenter.postLoginCode(kindOf: .login, callBackURLCode: callBackURLCode) { (result) in
            switch result {
            case .success(let data):
                let decodeResult = self.jsonProcessCenter.decodeData(typeOf: UserDTO.self, data: data)
                switch decodeResult {
                case .success(let userDTO):
                    DispatchQueue.main.async {
                        completion(.success(userDTO))
                    }
                case .failure(_):
                    completion(.failure(NetworkingError.decodeError))
                }
            case .failure(_):
                completion(.failure(NetworkingError.responseError))
            }
        }
    }
}

extension OAuthManager {
    func getClientID() -> String {
        guard let path = Bundle.main.path(forResource: "NetworkElements", ofType: "plist") else { return "" }
        let plist = NSDictionary(contentsOfFile: path)
        guard let key = plist?.object(forKey: "ClientID") as? String else { return "" }
        return key
    }
}
