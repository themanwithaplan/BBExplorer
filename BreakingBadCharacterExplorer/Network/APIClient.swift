//
//  APIClient.swift
//  BreakingBadCharacterExplorer
//
//  Created by Sharaf Nazaar on 12/10/20.
//

import Foundation

class APIClient {
    
    public var scheme: String = "https"
    public var host: String = "breakingbadapi.com"
    public var customEndPoint = "/api/characters"
    public var session = URLSession(configuration: .default)
    
    public init() {}
    
    public enum HTTPMethod: String {
        case get = "GET"
    }
    
    public func request(method: HTTPMethod, components: URLComponents, onComplete: @escaping (Result<Data?, RequestError>) -> Void) {
        
        guard let url = components.url else {
            onComplete(.failure(.init(message: "Could not create valid URL from components.")))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                onComplete(.failure(.init(message: "Did not get an http response")))
                return
            }
            
            if let error = error as NSError? {
                onComplete(.failure(.init(message: "\(response.statusCode): \(error.localizedDescription)")))
                return
            }
            
            onComplete(.success(data))
        }
        task.resume()
    }
        
    public func get(path: String, queryItems: [URLQueryItem]? = nil, onComplete: @escaping (Result<Data?, RequestError>) -> Void) {
        var components = self.components(path: path)
        components.queryItems = queryItems
        request(method: .get, components: components, onComplete: onComplete)
    }
    
    func components(path: String) -> URLComponents {
        var components = URLComponents()
        components.host = self.host
        components.path = path
        components.scheme = scheme
        return components
    }
    
    func getCharacters(completionHandler: @escaping (Characters?, Error?) -> Void) {
        
        self.get(path: customEndPoint, queryItems: nil)
        { (response) in
            switch response {
            case .success(let data):
                guard let jsonData = data else {
                    return
                }
            do {
                let decoder = JSONDecoder()
                let characterData = try decoder.decode(Characters.self, from: jsonData)
                completionHandler(characterData, nil)
            } catch {
                completionHandler(nil, error)
            }
              
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
}
public struct RequestError: Error {
    public var message: String
}
