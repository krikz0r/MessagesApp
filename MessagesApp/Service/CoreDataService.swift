//
//  CoreDataService.swift
//  MessagesApp
//
//  Created by Anton on 08.09.2022.
//

import CoreData
import Foundation

protocol CoreDataServiceProtocol {
    func delete(_ id: Int)
    func add(with message: String, and author: String)
    func fetch() -> [MessageData]
}

final class CoreDataService: CoreDataServiceProtocol {
    private var storedMessages: [MessageData] = [MessageData]()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MessagesApp")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error with core data")
            }
        }
        return container
    }()

    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private var currentId: Int {
        return Int(storedMessages.map { $0.messageId }.max() ?? 0)
    }

    func delete(_ id: Int) {
        let storedProperties = fetch()
        guard let message = storedProperties.first(where: { $0.messageId == Int16(id) }) else { return }
        viewContext.delete(message)
        storedMessages.removeAll(where: { $0.messageId == id })
        save()
    }

    func add(with message: String, and author: String) {
        let messageData = MessageData(context: viewContext)
        messageData.text = message
        messageData.author = author
        messageData.messageId = Int16(currentId + 1)
        save()
    }

    func fetch() -> [MessageData] {
        let request: NSFetchRequest<MessageData> = MessageData.fetchRequest()
        return (try? viewContext.fetch(request)) ?? []
    }

    private func save() {
        do {
            try viewContext.save()
        } catch {
        }
    }
}
