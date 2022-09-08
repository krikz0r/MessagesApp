//
//  MessagesListRouter.swift
//  MessagesApp
//
//  Created by Anton on 07.09.2022.
//

import Foundation
import UIKit
final class MessagesListRouter: MessagesListRouterInput {
    weak var viewController: UIViewController?

    func showAlert(with message: String, completion: @escaping (() -> Void)) {
        viewController?.showAlert(with: message, completion: completion)
    }

    func showDetail(with viewModel: MessageViewModel, completion: @escaping ((Bool) -> Void)) {
        let detailVC = DetailMessageViewController(viewModel: viewModel, callBack: completion)
        detailVC.modalPresentationStyle = .overFullScreen
        viewController?.present(detailVC, animated: false)
    }
}
