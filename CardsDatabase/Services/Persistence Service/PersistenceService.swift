//
//  PersistenceService.swift
//  CardsDatabase
//
//  Created by Meng Li on 20/06/2024.
//

import Foundation
import CoreData

protocol PersistenceServiceProtocol {
    func createRecords<T: NSManagedObject>(entityName: String, managedObjectHandler handler: @escaping (T) -> Bool) 
    func fetchRecords<T: NSManagedObject>(request: NSFetchRequest<T>, onCompletion: @escaping ([T]) -> Void)
    func deleteRecords<T: NSManagedObject>(request: NSFetchRequest<T>)
}

class PersistenceService: PersistenceServiceProtocol {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CardsDatabase", managedObjectModel: managedObjectModel)
        container.loadPersistentStores { _, error in
            if let error = error {
                NSLog("[Error] Unable to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()

    private lazy var managedContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let bundle = Bundle(identifier: "meng.li.CardsDatabase")!
        let modelURL = bundle.url(forResource: "CardsDatabase", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    func createRecords<T: NSManagedObject>(entityName: String, managedObjectHandler handler: @escaping (T) -> Bool) {
        managedContext.performAndWait { [weak self] in
            guard let self = self else { return }
            
            guard let handler = handler as? (NSManagedObject) -> Bool,
                  let entity = NSEntityDescription.entity(forEntityName: entityName, in: self.managedContext) else {
                NSLog("Couldn't initialise \(entityName) entity.")
                return
            }

            let request = NSBatchInsertRequest(entity: entity, managedObjectHandler: handler)
            do {
                try self.managedContext.execute(request)
            } catch {
                NSLog("[Error] Unresolved error \(error.localizedDescription)")
            }
        }
    }
    
    func fetchRecords<T: NSManagedObject>(request: NSFetchRequest<T>, onCompletion: @escaping ([T]) -> Void) {
        managedContext.performAndWait { [weak self] in
            guard let self = self else { return }
            
            do {
                let records = try self.managedContext.fetch(request)
                onCompletion(records)
            } catch {
                NSLog("[Error] Unresolved error \(error.localizedDescription)")
                onCompletion([])
            }
        }
    }

    func deleteRecords<T: NSManagedObject>(request: NSFetchRequest<T>) {
        managedContext.performAndWait({ [weak self] in
            guard let self = self else { return }
            
            guard let batchDeleteRequest = request as? NSFetchRequest<NSFetchRequestResult> else {
                NSLog("[Error] Failed to cast request to NSFetchRequest<NSFetchRequestResult>")
                return
            }

            let deleteRequest = NSBatchDeleteRequest(fetchRequest: batchDeleteRequest)
            do {
                try self.managedContext.execute(deleteRequest)
            } catch {
                NSLog("[Error] Unresolved error \(error.localizedDescription)")
            }
        })
    }
}
