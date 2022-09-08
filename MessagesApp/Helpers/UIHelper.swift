//
//  UIHelper.swift
//  MessagesApp
//
//  Created by Anton on 08.09.2022.
//

import Foundation
import UIKit
enum UIHelper {
    static func createSpinner(height: CGFloat) -> UIView {
        let footerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: height)))

        let conteinerView = UIView()
        conteinerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(conteinerView)
        conteinerView.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        conteinerView.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        conteinerView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        conteinerView.heightAnchor.constraint(equalToConstant: 30).isActive = true

        conteinerView.backgroundColor = .white
        conteinerView.layer.cornerRadius = 5

        let spinner = UIActivityIndicatorView()
        spinner.transform = CGAffineTransform(scaleX: 1, y: -1)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        conteinerView.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: conteinerView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: conteinerView.centerYAnchor).isActive = true
        spinner.startAnimating()
        return footerView
    }
}
