//
//  NetworkService.swift
//  MessagesApp
//
//  Created by Anton on 07.09.2022.
//

import Foundation
protocol NetworkServiceProtocol: AnyObject {
    func sendRequest(with offset: Int, completion: @escaping ((Result<Data, NetworkErrors>) -> Void))
}

enum NetworkErrors: Error {
    case badURL
    case responseError(String)
}

final class NetworkService: NetworkServiceProtocol {
    func sendRequest(with offset: Int, completion: @escaping ((Result<Data, NetworkErrors>) -> Void)) {
        guard let url = URL(string: Constants.URLS.baseURL + String(offset)) else {
            completion(.failure(.badURL))
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                completion(.success(data))
            }

            if let error = error {
                completion(.failure(.responseError(error.localizedDescription)))
            }

        }.resume()
    }
}
