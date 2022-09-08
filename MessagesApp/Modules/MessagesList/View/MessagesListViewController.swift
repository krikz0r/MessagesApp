//
//  ViewController.swift
//  MessagesApp
//
//  Created by Anton on 07.09.2022.
//

import UIKit

class MessagesListViewController: UIViewController {
    // MARK: - Subviews

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let titleView: TitleView = {
        let view = TitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let textFieldContainer: TextFieldContainerView = {
        let view = TextFieldContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Properties

    private var textViewBottomConstraint: NSLayoutConstraint?
    var presenter: MessagesListViewOutput!

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        configureTable()
        presenter.viewDidLoad()
        bindUI()
    }

    // MARK: - Setup UI

    private func bindUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        textFieldContainer.callBack = { [weak self] text in
            self?.presenter.approveButtonAction(with: text)
        }
    }

    private func configureTable() {
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.reuseId)
        tableView.separatorStyle = .none
    }

    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(titleView)
        view.addSubview(textFieldContainer)

        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 50),

            tableView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: textFieldContainer.topAnchor),

            textFieldContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textFieldContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textFieldContainer.heightAnchor.constraint(equalToConstant: 60),
        ])

        textViewBottomConstraint = textFieldContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        textViewBottomConstraint?.isActive = true
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardHeight = targetFrame.height
        textViewBottomConstraint?.constant = -keyboardHeight
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        textViewBottomConstraint?.constant = 0
    }
}

// MARK: - MessagesListViewInput

extension MessagesListViewController: MessagesListViewInput {
    func startLoading() {
        DispatchQueue.main.async {
            self.tableView.tableFooterView = UIHelper.createSpinner(height: 100)
        }
    }

    func stopLoading() {
        DispatchQueue.main.async {
            self.tableView.tableFooterView = nil
        }
    }

    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func insertRow(at index: Int) {
        DispatchQueue.main.async {
            self.tableView.performBatchUpdates {
                self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .left)
            }
        }
    }

    func removeRow(at index: Int) {
        DispatchQueue.main.async {
            self.tableView.performBatchUpdates {
                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .right)
            }
        }
    }
}

// MARK: - Extension UITableView DataSource & Delegate

extension MessagesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.reuseId, for: indexPath) as! MessageTableViewCell
        let currentViewModel = presenter.currentMessage(for: indexPath.row)
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        cell.configure(with: currentViewModel)
        presenter.toggleAnimation(for: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath.row)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        let topPoint = scrollView.contentOffset.y + scrollView.bounds.size.height
        let pointToLoad = scrollView.contentSize.height
        presenter.viewDidScroll(topPoint: topPoint, pointToLoad: pointToLoad)
    }
}
