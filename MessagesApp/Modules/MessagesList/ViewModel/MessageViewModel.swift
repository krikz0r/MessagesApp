//
//  MessageViewModel.swift
//  MessagesApp
//
//  Created by Anton on 07.09.2022.
//

import Foundation

struct MessageViewModel {
    let authorName: String
    let text: String
    let byUser: Bool
    let imageURL:String
    let messageId: Int
    var animatable: Bool = true
    let date: String
}
