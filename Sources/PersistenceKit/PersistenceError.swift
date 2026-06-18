//
//  PersistenceError.swift
//  PersistenceKit
//
//  Created by Prakash on 18/06/2026.
//

import Foundation

public enum PersistenceError: Error, LocalizedError {
    case storeLoadFailed(Error)
    case saveFailed(Error)
    case fetchFailed(Error)
    case encodingFailed(Error)
    case decodingFailed(Error)

    public var errorDescription: String? {
        switch self {
        case .storeLoadFailed(let e):  return "Failed to load persistent store: \(e.localizedDescription)"
        case .saveFailed(let e):       return "Save failed: \(e.localizedDescription)"
        case .fetchFailed(let e):      return "Fetch failed: \(e.localizedDescription)"
        case .encodingFailed(let e):   return "Encoding failed: \(e.localizedDescription)"
        case .decodingFailed(let e):   return "Decoding failed: \(e.localizedDescription)"
        }
    }
}
