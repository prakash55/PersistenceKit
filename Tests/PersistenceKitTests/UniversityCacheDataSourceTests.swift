//
//  UniversityCacheDataSourceTests.swift
//  PersistenceKitTests
//
//  Created by Prakash on 18/06/2026.
//

import XCTest
@testable import PersistenceKit
import DomainKit

final class UniversityCacheDataSourceTests: XCTestCase {

    private var sut: UniversityCacheDataSource!

    override func setUp() throws {
        let stack = try CoreDataStack(inMemory: true)
        sut = UniversityCacheDataSource(stack: stack)
    }

    override func tearDown() {
        sut = nil
    }

    func testSaveAndLoadRoundTrip() async throws {
        let universities = [
            University(name: "MIT", country: "United States", alphaTwoCode: "US",
                       domains: ["mit.edu"], webPages: ["http://web.mit.edu/"], stateProvince: nil)
        ]

        try await sut.save(universities: universities, country: "United States")
        let loaded = try await sut.load(country: "United States")

        XCTAssertEqual(loaded?.count, 1)
        XCTAssertEqual(loaded?.first?.name, "MIT")
        XCTAssertEqual(loaded?.first?.country, "United States")
    }

    func testLoadReturnsNilForUnknownCountry() async throws {
        let result = try await sut.load(country: "NonExistentCountry")
        XCTAssertNil(result)
    }

    func testSaveOverwritesExistingEntry() async throws {
        let first = [University(name: "MIT", country: "US", alphaTwoCode: "US",
                                domains: [], webPages: [], stateProvince: nil)]
        let second = [
            University(name: "MIT", country: "US", alphaTwoCode: "US",
                       domains: [], webPages: [], stateProvince: nil),
            University(name: "Harvard", country: "US", alphaTwoCode: "US",
                       domains: [], webPages: [], stateProvince: nil)
        ]

        try await sut.save(universities: first, country: "US")
        try await sut.save(universities: second, country: "US")

        let loaded = try await sut.load(country: "US")
        XCTAssertEqual(loaded?.count, 2)
    }

    func testSaveAndLoadMultipleCountries() async throws {
        let us = [University(name: "MIT", country: "US", alphaTwoCode: "US",
                             domains: [], webPages: [], stateProvince: nil)]
        let uk = [University(name: "Oxford", country: "UK", alphaTwoCode: "GB",
                             domains: [], webPages: [], stateProvince: nil)]

        try await sut.save(universities: us, country: "US")
        try await sut.save(universities: uk, country: "UK")

        XCTAssertEqual(try await sut.load(country: "US")?.first?.name, "MIT")
        XCTAssertEqual(try await sut.load(country: "UK")?.first?.name, "Oxford")
    }

    func testSaveEmptyArrayAndLoad() async throws {
        try await sut.save(universities: [], country: "Empty")
        let loaded = try await sut.load(country: "Empty")
        XCTAssertEqual(loaded?.count, 0)
    }
}
