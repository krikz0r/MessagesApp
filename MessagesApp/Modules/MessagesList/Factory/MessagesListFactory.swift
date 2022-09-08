//
//  MessagesListFactory.swift
//  MessagesApp
//
//  Created by Anton on 07.09.2022.
//

import Foundation
import UIKit
enum MessagesListFactory {
    static func createModule() -> UIViewController {
        let viewController = MessagesListViewController()
        let router = MessagesListRouter()
        let presenter = MessageListPresenter(view: viewController,
                                             router: router,
                                             networkService: NetworkService(),
                                             coreDataService: CoreDataService())
        viewController.presenter = presenter
        router.viewController = viewController
        return viewController
    }
}
