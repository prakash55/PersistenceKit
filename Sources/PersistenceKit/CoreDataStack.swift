//
//  CoreDataStack.swift
//  PersistenceKit
//
//  Created by Prakash on 18/06/2026.
//

import CoreData
import Foundation

public final class CoreDataStack: @unchecked Sendable {
    private let container: NSPersistentContainer

    public init(inMemory: Bool = false) throws {
        container = NSPersistentContainer(
            name: "UniversityCache",
            managedObjectModel: CoreDataStack.makeModel()
        )

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        var storeError: Error?
        container.loadPersistentStores { _, error in storeError = error }
        if let error = storeError {
            throw PersistenceError.storeLoadFailed(error)
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        container.newBackgroundContext()
    }

    // MARK: - Programmatic Core Data model (no .xcdatamodeld file needed in SPM)

    private static func makeModel() -> NSManagedObjectModel {
        let entity = NSEntityDescription()
        entity.name = "UniversityCache"
        entity.managedObjectClassName = NSStringFromClass(UniversityCacheEntity.self)

        let country = NSAttributeDescription()
        country.name = "country"
        country.attributeType = .stringAttributeType
        country.isOptional = false

        let jsonData = NSAttributeDescription()
        jsonData.name = "jsonData"
        jsonData.attributeType = .binaryDataAttributeType
        jsonData.isOptional = false

        let savedAt = NSAttributeDescription()
        savedAt.name = "savedAt"
        savedAt.attributeType = .dateAttributeType
        savedAt.isOptional = false

        entity.properties = [country, jsonData, savedAt]

        let model = NSManagedObjectModel()
        model.entities = [entity]
        return model
    }
}
