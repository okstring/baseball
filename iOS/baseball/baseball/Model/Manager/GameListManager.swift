//
//  GameManager.swift
//  baseball
//
//  Created by Issac on 2021/05/06.
//

import Foundation

final class GameListManager {
    private let networkingCenter: ServerCommunicable
    private let jsonProcessCenter: JSONDecodable
    private(set) var token: String?
    
    init(serverCommunicable: ServerCommunicable, JSONDecodable: JSONDecodable) {
        self.networkingCenter = serverCommunicable
        self.jsonProcessCenter = JSONDecodable
    }
    
    func setToken(token: String) {
        self.token = token
    }
    
    func getRequest<T: Decodable>(of path: Path, completion: @escaping ((Result<T, NetworkingError>) -> ())) {
        self.networkingCenter.request(path: .gameList, token: self.token) { (result) in
            switch result {
            case .success(let data):
                let decodeResult = self.jsonProcessCenter.decodeData(typeOf: T.self, data: data)
                switch decodeResult {
                case .success(let dto):
                    DispatchQueue.main.async {
                        completion(.success(dto))
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
