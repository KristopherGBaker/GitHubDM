//
//  Persistence.swift
//  GitHubDMModel
//
//  Created by Kris Baker on 9/8/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import CoreData
import Foundation
import os.log

/// Persistence provides a Core Data based implementation
/// of the `Persisting` protocol.
public final class Persistence: NSPersistentContainer, Persisting {
    
    /// The background context for loading and saving messages.
    private lazy var backgroundContext: NSManagedObjectContext = {
        return newBackgroundContext()
    }()
    
    /// Initializes the persistent store.
    /// - Returns:
    ///     An initialized `Persistence`.
    public convenience init() {
        self.init(name: "PersistenceModel")
        loadPersistentStores {
            storeDescription, error in
            
            if let error = error as NSError? {
                // TODO: Provide error handling instead of just logging.
                os_log("Unresolved error %@, %@)", type: .error, error, error.userInfo)
            }
        }
    }
    
    public func loadMessages(for userId: Int64,
                      failure: ((Error) -> Void)?,
                      success: (([Message]) -> Void)?) {
        backgroundContext.perform { [backgroundContext] in
            let request = PersistenceMessage.createFetchRequest()
            request.predicate = NSPredicate(format: "fromUserId == %ld OR toUserId == %ld", userId, userId)
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
            do {
                let persistenceMessages = try backgroundContext.fetch(request)
                let messages = persistenceMessages.map { $0.convertToMessage() }
                DispatchQueue.main.async {
                    success?(messages)
                }
            } catch {
                DispatchQueue.main.async {
                    failure?(error)
                }
            }
        }
    }
    
    public func saveMessage(_ message: Message,
                            complete: (() -> Void)?) {
        backgroundContext.perform { [backgroundContext] in
            let persistenceMessage = PersistenceMessage(context: backgroundContext)
            persistenceMessage.createdAt = message.createdAt as NSDate
            persistenceMessage.text = message.text
            persistenceMessage.fromUserId = message.fromUserId
            persistenceMessage.toUserId = message.toUserId
            persistenceMessage.messageType = message.messageType.description
            
            backgroundContext.insert(persistenceMessage)
            
            DispatchQueue.main.async {
                complete?()
            }
        }
    }
    
    public func save() {
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        
        if backgroundContext.hasChanges {
            try? backgroundContext.save()
        }
    }
    
    public func deleteAllMessages(failure: ((Error) -> Void)?,
                                  success: (() -> Void)?) {
        backgroundContext.perform { [backgroundContext] in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PersistenceMessage")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            
            do {
                _ = try backgroundContext.execute(deleteRequest)
                DispatchQueue.main.async {
                    success?()
                }
            } catch {
                DispatchQueue.main.async {
                    failure?(error)
                }
            }
        }
    }
    
}
