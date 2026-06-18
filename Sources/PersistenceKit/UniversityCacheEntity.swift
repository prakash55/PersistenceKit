//
//  UniversityCacheEntity.swift
//  PersistenceKit
//
//  Created by Prakash on 18/06/2026.
//

import CoreData

@objc(UniversityCacheEntity)
final class UniversityCacheEntity: NSManagedObject {
    @NSManaged var country: String
    @NSManaged var jsonData: Data
    @NSManaged var savedAt: Date
}
