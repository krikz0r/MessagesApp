//
//  Extension + UITextField.swift
//  MessagesApp
//
//  Created by Anton on 07.09.2022.
//

import UIKit
extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.size.height))
        leftView = paddingView
        leftViewMode = .always
    }
}
