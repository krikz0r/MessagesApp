//
//  MessageData+CoreDataProperties.swift
//  MessagesApp
//
//  Created by Anton on 08.09.2022.
//
//

import Foundation
import CoreData


extension MessageData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageData> {
        return NSFetchRequest<MessageData>(entityName: "MessageData")
    }

    @NSManaged public var author: String?
    @NSManaged public var text: String?
    @NSManaged public var messageId: Int16
}

extension MessageData : Identifiable {

}
