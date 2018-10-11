//
//  PersistenceMessage+CoreDataProperties.swift
//  GitHubDMModel
//
//  Created by Kris Baker on 9/8/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//
//

import Foundation
import CoreData

/// Core Data generated extension for `PersistenceMessage`.
extension PersistenceMessage {

    @nonobjc internal class func createFetchRequest() -> NSFetchRequest<PersistenceMessage> {
        return NSFetchRequest<PersistenceMessage>(entityName: "PersistenceMessage")
    }

    @NSManaged internal var createdAt: NSDate?
    @NSManaged internal var text: String?
    @NSManaged internal var toUserId: Int64
    @NSManaged internal var fromUserId: Int64
    @NSManaged internal var messageType: String?

}
