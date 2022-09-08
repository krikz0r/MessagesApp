//
//  TextFieldContainerView.swift
//  MessagesApp
//
//  Created by Anton on 07.09.2022.
//

import Foundation
import UIKit
final class TextFieldContainerView: UIView {
    
    //MARK: - Subviews
    
    private let inputTextField: UITextField = {
        let inputTextField = UITextField()
        inputTextField.layer.cornerRadius = 8
        inputTextField.layer.borderWidth = 2
        inputTextField.layer.borderColor = UIColor.systemGray2.cgColor
        inputTextField.clipsToBounds = true
        inputTextField.textColor = .label
        inputTextField.font = UIFont.systemFont(ofSize: 16)
        inputTextField.autocorrectionType = .no
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.tintColor = .systemGray3
        inputTextField.placeholder = "Введите текст"
        inputTextField.setLeftPaddingPoints(15)
        return inputTextField
    }()
    
    //MARK: - Properties
    var callBack: ((String?) -> Void)?
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        backgroundColor = .systemBackground
        inputTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
    private func setupUI() {
        addSubview(inputTextField)
        NSLayoutConstraint.activate([
            inputTextField.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            inputTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            inputTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            inputTextField.heightAnchor.constraint(equalToConstant: 50 + safeAreaInsets.bottom),
        ])
    }
}


//MARK: - UITextFieldDelegate
extension TextFieldContainerView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        callBack?(textField.text)
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}
