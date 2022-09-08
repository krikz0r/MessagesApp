//
//  MessagesListProtocols.swift
//  MessagesApp
//
//  Created by Anton on 07.09.2022.
//

import Foundation

//MARK: - Presenter -> View
protocol MessagesListViewInput: AnyObject {
    func startLoading()
    func stopLoading()
    func reloadTable()
    func insertRow(at index: Int)
    func removeRow(at index: Int)
}

//MARK: - View -> Presenter
protocol MessagesListViewOutput: AnyObject {
    init(view: MessagesListViewInput?,
         router: MessagesListRouterInput,
         networkService: NetworkServiceProtocol,
         coreDataService: CoreDataServiceProtocol)
    func viewDidLoad()
    func viewDidScroll(topPoint: Double, pointToLoad: Double)
    func numberOfRows() -> Int
    func currentMessage(for index: Int) -> MessageViewModel
    func approveButtonAction(with text: String?)
    func didSelectRow(at index: Int)
    func toggleAnimation(for index: Int)
}


//MARK: - Presenter -> Router
protocol MessagesListRouterInput: AnyObject {
    func showAlert(with message: String, completion: @escaping (() -> Void))
    func showDetail(with viewModel: MessageViewModel, completion: @escaping ((Bool) -> Void))
}
