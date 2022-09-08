//
//  MessageListPresenter.swift
//  MessagesApp
//
//  Created by Anton on 07.09.2022.
//

import Foundation

final class MessageListPresenter: NSObject, MessagesListViewOutput {
    
    //MARK: - Properties
    private var coreDataService: CoreDataServiceProtocol
    private weak var view: MessagesListViewInput?
    private var router: MessagesListRouterInput
    private var networkService: NetworkServiceProtocol?
    private var viewModels: [MessageViewModel] = [MessageViewModel]()
    private var isStartLoading: Bool = false
    private var lastScrollViewOffest: Double = 0
    private var messagesOffset: Int = 0
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:MM "
        return dateFormatter
    }()
    
    //MARK: - Init

    init(view: MessagesListViewInput?,
         router: MessagesListRouterInput,
         networkService: NetworkServiceProtocol,
         coreDataService: CoreDataServiceProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
        self.coreDataService = coreDataService
    }
    
    //MARK: - Protocol requirements

    func viewDidLoad() {
        fetchStoredMessages()
        loadExternalMessages(isFromViewDidLoad: true)
    }

    func viewDidScroll(topPoint: Double, pointToLoad: Double) {
        if topPoint > lastScrollViewOffest {
            if topPoint >= pointToLoad {
                loadExternalMessages()
            }
        }
        lastScrollViewOffest = topPoint
    }

    func numberOfRows() -> Int {
        return viewModels.count
    }

    func currentMessage(for index: Int) -> MessageViewModel {
        let currentMessage = viewModels[index]
        return currentMessage
    }

    func approveButtonAction(with text: String?) {
        guard let text = text,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            router.showAlert(with: "Введите текст.") {
            }
            return
        }
        let viewModel = MessageViewModel(authorName: "Anton", text: text, byUser: true, imageURL: Constants.URLS.baseImagesURL, messageId: 0, date: dateFormatter.string(from: Date()))
        viewModels.insert(viewModel, at: 0)
        view?.insertRow(at: 0)
        coreDataService.add(with: viewModel.text, and: viewModel.authorName)
    }

    func didSelectRow(at index: Int) {
        let currentViewModel = viewModels[index]
        router.showDetail(with: currentViewModel) { [weak self] isByUser in
            if isByUser {
                self?.coreDataService.delete(currentViewModel.messageId)
            }
            let indexForRemove = self?.viewModels.firstIndex(where: { $0.messageId == index }) ?? 0
            self?.viewModels.remove(at: indexForRemove)
            self?.view?.removeRow(at: index)
        }
    }

    func toggleAnimation(for index: Int) {
        viewModels[index].animatable = false
    }
}


//MARK: - Extension
extension MessageListPresenter {
    private func fetchStoredMessages() {
        let messages = coreDataService.fetch().map({ stored in MessageViewModel(authorName: stored.author ?? "",
                                                                                text: stored.text ?? "",
                                                                                byUser: true,
                                                                                imageURL: Constants.URLS.baseImagesURL,
                                                                                messageId: Int(stored.messageId),
                                                                                date: dateFormatter.string(from: Date())) })
        viewModels.append(contentsOf: messages)
        view?.reloadTable()
    }

    private func loadExternalMessages(isFromViewDidLoad: Bool = false, currentAttempt: Int = 0) {
        guard !isStartLoading else { return }
        guard currentAttempt <= Constants.Properties.maxFailureLoadingAttempt else {
            router.showAlert(with: "BAD INTERNET CONNECTION , TRY LATER") {
            }
            return
        }
        isStartLoading = true
        view?.startLoading()
        networkService?.sendRequest(with: messagesOffset, completion: { [weak self] result in
            guard let self = self else { return }
            self.view?.stopLoading()
            self.isStartLoading = false
            switch result {
            case let .success(data):
                do {
                    let messages = try JSONDecoder().decode(ExternalEntities.self, from: data)
                    var externalMessagesViewModels: [MessageViewModel] = []
                    messages.result.enumerated().forEach { elemnt in
                        externalMessagesViewModels.append(MessageViewModel(authorName: Constants.randomString(length: 5),
                                                                           text: elemnt.element,
                                                                           byUser: false,
                                                                           imageURL: Constants.URLS.baseImagesURL,
                                                                           messageId: elemnt.offset + 1 + self.messagesOffset,
                                                                           date: self.dateFormatter.string(from: Date())))
                    }
                    self.messagesOffset += messages.result.count
                    self.viewModels += externalMessagesViewModels
                    self.view?.reloadTable()

                } catch {
                    if isFromViewDidLoad {
                        self.loadExternalMessages(isFromViewDidLoad: isFromViewDidLoad, currentAttempt: currentAttempt + 1)
                    } else {
                        self.router.showAlert(with: "OOPS! TRY AGAIN!") { [weak self] in
                            self?.loadExternalMessages(isFromViewDidLoad: isFromViewDidLoad, currentAttempt: currentAttempt + 1)
                        }
                    }
                }
            case let .failure(error):
                switch error {
                case .badURL:
                    self.router.showAlert(with: "BAD URL , CONTACT US BY E-MAIL ") {
                    }
                case let .responseError(message):
                    self.router.showAlert(with: message) {
                    }
                }
            }

        })
    }
}
