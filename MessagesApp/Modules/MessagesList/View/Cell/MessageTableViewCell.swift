//
//  MessageTableViewCell.swift
//  MessagesApp
//
//  Created by Anton on 08.09.2022.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    // MARK: - Subviews

    private let messageLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .left
        view.font = UIFont.systemFont(ofSize: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let messageTailImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let messageContentView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray3
        return imageView
    }()

    private let nameLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .left
        view.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Properties

    static let reuseId = String(describing: MessageTableViewCell.self)

    private var viewModel: MessageViewModel?

    private var messageContentConstraints: Array<NSLayoutConstraint> = []
    private var messageLabelConstraints: Array<NSLayoutConstraint> = []
    private var messageTailConstraints: Array<NSLayoutConstraint> = []
    private var messageLeftConstraint: NSLayoutConstraint?
    private var messageRightConstraint: NSLayoutConstraint?
    private var messageTailLeftConstraint: NSLayoutConstraint?
    private var messageTailRightConstraint: NSLayoutConstraint?
    private var avatarLeftConstraint: NSLayoutConstraint?
    private var avatarRightConstraint: NSLayoutConstraint?
    private var avatarImageConstraints: Array<NSLayoutConstraint> = []
    private var nameConstraints: Array<NSLayoutConstraint> = []

    private let messageTailImage = UIImage(named: "messageTail")
    
    //MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupUI()
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Configure UI

    override func prepareForReuse() {
        super.prepareForReuse()
        messageLeftConstraint?.isActive = false
        messageRightConstraint?.isActive = false
        messageTailLeftConstraint?.isActive = false
        messageTailRightConstraint?.isActive = false
        avatarRightConstraint?.isActive = false
        avatarLeftConstraint?.isActive = false
    }

    private func setupUI() {
        contentView.addSubview(messageContentView)
        contentView.addSubview(messageTailImageView)
        contentView.addSubview(avatarImageView)
        messageContentView.addSubview(messageLabel)
        messageContentView.addSubview(nameLabel)
        messageLeftConstraint = messageContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 75)
        messageRightConstraint = messageContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -75)

        messageTailLeftConstraint = messageTailImageView.leadingAnchor.constraint(equalTo: messageContentView.leadingAnchor, constant: -4)
        messageTailRightConstraint = messageTailImageView.trailingAnchor.constraint(equalTo: messageContentView.trailingAnchor, constant: 4)

        avatarLeftConstraint = avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17)
        avatarRightConstraint = avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17)

        messageTailConstraints = [
            messageTailImageView.widthAnchor.constraint(equalTo: messageTailImageView.heightAnchor),
            messageTailImageView.heightAnchor.constraint(equalToConstant: 11),
            messageTailImageView.bottomAnchor.constraint(equalTo: messageContentView.bottomAnchor),
        ]

        nameConstraints = [
            nameLabel.topAnchor.constraint(equalTo: messageContentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: messageContentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: messageContentView.trailingAnchor, constant: -10),
            nameLabel.bottomAnchor.constraint(equalTo: messageLabel.topAnchor),
        ]

        messageLabelConstraints = [
            messageLabel.bottomAnchor.constraint(equalTo: messageContentView.bottomAnchor, constant: -5),
            messageLabel.leadingAnchor.constraint(equalTo: messageContentView.leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: messageContentView.trailingAnchor, constant: -10),
        ]

        messageContentConstraints = [
            messageContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            messageContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            messageContentView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.66),
        ]

        avatarImageConstraints = [
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            avatarImageView.bottomAnchor.constraint(equalTo: messageContentView.bottomAnchor),
        ]

        NSLayoutConstraint.activate(avatarImageConstraints)
        NSLayoutConstraint.activate(messageContentConstraints)
        NSLayoutConstraint.activate(messageLabelConstraints)
        NSLayoutConstraint.activate(messageTailConstraints)
        NSLayoutConstraint.activate(nameConstraints)
    }

    func configure(with message: MessageViewModel) {
        viewModel = message

        nameLabel.text = message.authorName
        messageLabel.text = message.text
        messageLeftConstraint?.isActive = !message.byUser
        messageRightConstraint?.isActive = message.byUser
        messageTailLeftConstraint?.isActive = !message.byUser
        messageTailRightConstraint?.isActive = message.byUser
        avatarRightConstraint?.isActive = message.byUser
        avatarLeftConstraint?.isActive = !message.byUser

        if message.animatable {
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {
                self.layoutIfNeeded()
            })
        }
        messageLabel.textColor = .label
        messageTailImageView.tintColor = message.byUser ? .systemPurple : .systemGray3
        messageContentView.backgroundColor = message.byUser ? .systemPurple : .systemGray3
        messageTailImageView.image = message.byUser ? messageTailImage?.imageRotatedByDegrees(0, flip: true).withRenderingMode(.alwaysTemplate) : messageTailImage

        let urlPath = message.byUser ? "USER" : "\(message.messageId)"
        ImagesDownloaderService.shared.fetchImage(from: message.imageURL + urlPath) { [weak self] image in
            DispatchQueue.main.async {
                self?.avatarImageView.image = image
            }
        }
    }
}
