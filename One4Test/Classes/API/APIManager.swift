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
        
        private static let token = "114e209a699a620fe18b9bcbe715c84325fcacb7"
        
        static func getStargazers(
            forRepo repo: String,
            resultsPerPage: Int,
            page: Int,
            completion: @escaping (Result<[String], Error>) -> Void) {
            
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
                "https://api.github.com/repos/andrealufino/Luminous/stargazers",
                method: .get,
                parameters: params,
                encoder: URLEncodedFormParameterEncoder.default,
                headers: HTTPHeaders.init(headers))
                .responseJSON { (response) in
                    
                    switch response.result {
                    case .success(_):
                        if let value = response.value {
                            let json = JSON(value)
                            
                            print("JSON\n1: \(json.arrayValue.first!["login"].stringValue)")
                        }
                    case .failure(let error):
                        print("Error!\n\(error.localizedDescription)")
                    }
                }
        }
    }
    
    
}
