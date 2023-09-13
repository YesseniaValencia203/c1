//
//  Extensions+URLSession.swift
//  codeChallenge
//
//  Created by Consultant on 9/12/23.
//

import Foundation

extension URLSession {
    enum RequestError: Error {
        case badURL
        case badData
    }
    func getRequest<T:Codable>(url: URL?, decoding: T.Type, completion: @escaping (Result<T, Error>) -> ()) {
        guard let url = url else {
            completion(.failure(RequestError.badURL))
            return
        }
        
        let task = self.dataTask(with: url) { data, _, error in
            guard data != nil else {
                completion(.failure(RequestError.badData))
                return
            }
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                let jsonResult = try JSONDecoder().decode(decoding, from: data!)
                completion(.success(jsonResult))
                
            } catch {
                completion(.failure(error))
                
            }
        }
        task.resume()
    }
}
