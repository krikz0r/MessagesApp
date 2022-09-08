//
//  Constants.swift
//  MessagesApp
//
//  Created by Anton on 07.09.2022.
//

import Foundation

enum Constants {
    enum URLS {
        static let baseURL: String = "https://numia.ru/api/getMessages?offset="
        static let baseImagesURL: String = "https://via.placeholder.com/100x100.png?text="
    }

    enum Properties {
        static let maxFailureLoadingAttempt = 5
    }

    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0 ..< length).map { _ in letters.randomElement()! })
    }
}
