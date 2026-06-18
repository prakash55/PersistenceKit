//
//  PersistenceErrorTests.swift
//  PersistenceKitTests
//
//  Created by Prakash on 18/06/2026.
//

import XCTest
@testable import PersistenceKit

final class PersistenceErrorTests: XCTestCase {

    private let underlying = NSError(domain: "test", code: 1,
                                     userInfo: [NSLocalizedDescriptionKey: "test reason"])

    func testStoreLoadFailedDescription() {
        let error = PersistenceError.storeLoadFailed(underlying)
        XCTAssertTrue(error.errorDescription?.contains("test reason") ?? false)
    }

    func testSaveFailedDescription() {
        let error = PersistenceError.saveFailed(underlying)
        XCTAssertTrue(error.errorDescription?.contains("test reason") ?? false)
    }

    func testFetchFailedDescription() {
        let error = PersistenceError.fetchFailed(underlying)
        XCTAssertTrue(error.errorDescription?.contains("test reason") ?? false)
    }

    func testEncodingFailedDescription() {
        let error = PersistenceError.encodingFailed(underlying)
        XCTAssertTrue(error.errorDescription?.contains("test reason") ?? false)
    }

    func testDecodingFailedDescription() {
        let error = PersistenceError.decodingFailed(underlying)
        XCTAssertTrue(error.errorDescription?.contains("test reason") ?? false)
    }
}
