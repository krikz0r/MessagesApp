//
//  ImagesDownloaderService.swift
//  MessagesApp
//
//  Created by Anton on 07.09.2022.
//

import Foundation
import UIKit

final class ImagesDownloaderService {
    static let shared = ImagesDownloaderService()
    fileprivate init() {}

    private let cache = NSCache<NSString, UIImage>()

    func fetchImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)

        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }

        guard let url = URL(string: urlString) else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data)
            else {
                completed(nil)
                return
            }
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }.resume()
    }
}
