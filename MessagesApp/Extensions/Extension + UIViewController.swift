//
//  Extension + UIViewController.swift
//  MessagesApp
//
//  Created by Anton on 07.09.2022.
//

import Foundation
import UIKit
extension UIViewController {
    func showAlert(with message: String, completion: @escaping (() -> Void)) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                completion()
            }))
            self.present(alertController, animated: true)
        }
    }
}
