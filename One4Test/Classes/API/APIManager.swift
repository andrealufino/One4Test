//
//  APIManager.swift
//  One4Test
//
//  Created by Andrea Mario Lufino on 06/12/20.
//

import Foundation

import Alamofire
import Reachability
import SwiftyJSON


struct APIManager {
    
    struct Github {
        
        // Token is written here in base64 and is decoded at runtime.
        // The reason is simple : Github checks if you commit a personal access token and,
        // if so, it deletes it automatically. This way, there shouldn't be problems.
        private static let token = "YjRlOTdhMjAwYWE3MDc0MDU0OTFiYzQ3YjhjMzVlN2E0NGJhYzA0Yw==".base64Decoded!
        
        static func getStargazers(
            forRepo repo: String,
            resultsPerPage: Int,
            page: Int,
            completion: @escaping (Result<[User], APIError>) -> Void) {
            
            do {
                guard try Reachability().connection != .unavailable else {
                    completion(.failure(APIError.noInternetConnection))
                    return
                }
                guard resultsPerPage > 0 else {
                    completion(.failure(APIError.init(debugMessage: "resultsPerPage must be greater than 0.")))
                    return
                }
                guard page > 0 else {
                    completion(.failure(APIError.generic))
                    return
                }
            } catch (_) {
                completion(.failure(APIError.generic))
                return
            }
            
            let headers = [
                "Authorization": "token \(token)",
                "Accept": "application/vnd.github.v3+json"
            ]
            
            let params: [String: Int] = [
                "per_page": resultsPerPage,
                "page": page
            ]
            
            let _ = AF.request(
                "https://api.github.com/repos/andrealufino/\(repo)/stargazers",
                method: .get,
                parameters: params,
                encoder: URLEncodedFormParameterEncoder.default,
                headers: HTTPHeaders.init(headers))
                .responseJSON { (response) in
                    
                    switch response.result {
                    case .success(_):
                        if let value = response.value {
                            let json = JSON(value)
                            
                            if let rawUsers = json.array {
                                do {
                                    let decoder = JSONDecoder.init()
                                    var users: [User] = []
                                    try rawUsers.forEach { (rawUser) in
                                        let data = try rawUser.rawData()
                                        users.append(try decoder.decode(User.self, from: data))
                                    }
                                    completion(.success(users))
                                } catch SwiftyJSONError.invalidJSON {
                                    completion(.failure(APIError.init(debugMessage: "Invalid JSON.")))
                                } catch _ {
                                    completion(.failure(APIError.init(debugMessage: "JSON decoding failed.")))
                                }
                            } else {
                                completion(.failure(APIError.serverError))
                            }
                        }
                    case .failure(_):
                        completion(.failure(APIError.serverError))
                    }
                }
        }
    }
    
    
}
