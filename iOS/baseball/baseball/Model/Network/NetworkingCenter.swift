//
//  NetworkingCenter.swift
//  baseball
//
//  Created by Issac on 2021/05/06.
//

import Foundation

protocol ServerCommunicable {
    func postLoginCode(path: Path, callBackURLCode: String, complete: @escaping (Result<Data, NetworkingError>) -> ())
    func request(path: Path, token: String?, parameter: String?, complete: @escaping (Result<Data, NetworkingError>) -> ())
}

final class NetworkingCenter: ServerCommunicable {
    func postLoginCode(path: Path, callBackURLCode: String, complete: @escaping (Result<Data, NetworkingError>) -> ()) {
        guard let url = Endpoint.url(path: .login, callBackUrlCode: callBackURLCode) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = path.needHTTPMethod.rawValue
        
        URLSession.init(configuration: .default).dataTask(with: urlRequest) { (data, response, error) in
            if let error = self.handleError(data: data, response: response, error: error) {
                complete(.failure(error))
            } else if let data = data {
                complete(.success(data))
            }
        }.resume()
    }
    
    func request(path: Path, token: String? = nil, parameter: String? = nil, complete: @escaping (Result<Data, NetworkingError>) -> ()) {
        guard let url = Endpoint.url(path: path, parameter: parameter ?? "") else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = path.needHTTPMethod.rawValue
        if let token = token {
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.init(configuration: .default).dataTask(with: urlRequest) { (data, response, error) in
            if let error = self.handleError(data: data, response: response, error: error) {
                complete(.failure(error))
            } else if let data = data {
                complete(.success(data))
            }
        }.resume()
    }
}

extension NetworkingCenter {
    private func getHOST() -> String {
        guard let path = Bundle.main.path(forResource: "NetworkElements", ofType: "plist") else { return "" }
        let plist = NSDictionary(contentsOfFile: path)
        guard let key = plist?.object(forKey: "Host") as? String else { return "" }
        return key
    }
    
    private func handleError(data: Data?, response: URLResponse?, error: Error?) -> NetworkingError? {
        if let error = error as NSError?, error.domain == NSURLErrorDomain, error.code == NSURLErrorNotConnectedToInternet {
            return NetworkingError.notConnectedToInternet
        }
        
        guard let httpResponse = response as? HTTPURLResponse, data != nil else {
            return NetworkingError.networkError
        }
        guard 200..<300 ~= httpResponse.statusCode else {
            #if DEBUG
            NSLog("\(httpResponse.statusCode)")
            #endif
            return NetworkingError.responseError
        }
        return nil
    }
}
