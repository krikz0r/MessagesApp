//
//  DetailMessageViewController.swift
//  MessagesApp
//
//  Created by Anton on 08.09.2022.
//

import Foundation
import UIKit
final class DetailMessageViewController: UIViewController {
    
    //MARK: - Subviews
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .red
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .placeholderText
        return label
    }()

    private let messageTextView: UITextView = {
        let messageTextView = UITextView()
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.font = .systemFont(ofSize: 17)
        messageTextView.backgroundColor = .clear
        messageTextView.textColor = .label
        messageTextView.isUserInteractionEnabled = false
        return messageTextView
    }()

    private let deleteButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        return button
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        view.backgroundColor = .systemBackground
        return view
    }()
    
    //MARK: - Properties

    private var viewModel: MessageViewModel!
    private var callBack: ((Bool) -> Void)?
    
    //MARK: - View lifecycle

    
    init(viewModel: MessageViewModel,callBack: @escaping ((Bool) -> Void) ) {
        self.viewModel = viewModel
        self.callBack = callBack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUI()
        fillData()
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1) { [weak self] in
            self?.view.backgroundColor = .black.withAlphaComponent(0.5)
            self?.containerView.alpha = 1
        }
    }
    
    //MARK: - Actions

    @objc func closeAction() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.containerView.alpha = 0
        } completion: { [weak self] _ in
            self?.dismiss(animated: false)
        }
    }

    @objc func deleteAction() {
        closeAction()
        callBack?(viewModel.byUser)
    }
    
    //MARK: - Setup subviews

    private func setupUI() {
        view.addSubview(containerView)

        containerView.addSubview(avatarImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(messageTextView)
        containerView.addSubview(deleteButton)
        containerView.addSubview(closeButton)

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7),
            containerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7),
        ])

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            avatarImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),

            nameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),

            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            messageTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            messageTextView.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            messageTextView.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
            messageTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -50),

            closeButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -30),
            closeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            deleteButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 30),
            deleteButton.bottomAnchor.constraint(equalTo: closeButton.bottomAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 30),
            deleteButton.widthAnchor.constraint(equalToConstant: 30),

        ])
    }

    private func configureUI() {
        containerView.layer.cornerRadius = 20
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.layer.masksToBounds = true
    }

    private func fillData() {
        nameLabel.text = viewModel.authorName
        messageTextView.text = viewModel.text
        dateLabel.text = viewModel.date
        let urlPath = viewModel.byUser ? "USER" : String(viewModel.messageId)
        ImagesDownloaderService.shared.fetchImage(from: viewModel.imageURL + urlPath) { [weak self] image in
            DispatchQueue.main.async {
                self?.avatarImageView.image = image
            }
        }
    }
}
