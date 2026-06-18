//
//  UniversityCacheDataSource.swift
//  PersistenceKit
//
//  Created by Prakash on 18/06/2026.
//

import CoreData
import Foundation
import DomainKit

public protocol UniversityCacheDataSourceProtocol: Sendable {
    func save(universities: [University], country: String) async throws
    func load(country: String) async throws -> [University]?
}

public final class UniversityCacheDataSource: UniversityCacheDataSourceProtocol, @unchecked Sendable {
    private let stack: CoreDataStack

    public init(stack: CoreDataStack) {
        self.stack = stack
    }

    public func save(universities: [University], country: String) async throws {
        let data = try encode(universities)
        let ctx = stack.newBackgroundContext()
        try await ctx.perform {
            let entry = try self.fetchOrCreate(country: country, in: ctx)
            entry.jsonData = data
            entry.savedAt = Date()
            try ctx.save()
        }
    }

    public func load(country: String) async throws -> [University]? {
        let ctx = stack.newBackgroundContext()
        return try await ctx.perform {
            guard let entry = try self.fetch(country: country, in: ctx) else { return nil }
            return try self.decode(entry.jsonData)
        }
    }

    // MARK: - Private helpers

    private func encode(_ universities: [University]) throws -> Data {
        do { return try JSONEncoder().encode(universities) }
        catch { throw PersistenceError.encodingFailed(error) }
    }

    private func decode(_ data: Data) throws -> [University] {
        do { return try JSONDecoder().decode([University].self, from: data) }
        catch { throw PersistenceError.decodingFailed(error) }
    }

    private func fetch(country: String, in ctx: NSManagedObjectContext) throws -> UniversityCacheEntity? {
        let request = NSFetchRequest<UniversityCacheEntity>(entityName: "UniversityCache")
        request.predicate = NSPredicate(format: "country == %@", country)
        request.fetchLimit = 1
        do { return try ctx.fetch(request).first }
        catch { throw PersistenceError.fetchFailed(error) }
    }

    private func fetchOrCreate(country: String, in ctx: NSManagedObjectContext) throws -> UniversityCacheEntity {
        if let existing = try fetch(country: country, in: ctx) { return existing }
        let entry = UniversityCacheEntity(context: ctx)
        entry.country = country
        return entry
    }
}

extension UniversityCacheDataSource {
    public static func makeDefault() throws -> UniversityCacheDataSource {
        let stack = try CoreDataStack()
        return UniversityCacheDataSource(stack: stack)
    }
}
