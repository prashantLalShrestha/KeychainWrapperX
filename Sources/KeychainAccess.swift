//
//  KeychainAccess.swift
//  KeychainWrapperX
//
//  Created by Prashant Shrestha on 5/17/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import Foundation
import KeychainAccess


public class KeychainAccess {
    
    private let keychain: Keychain
    
    private let service: String
    
    public init(service: String) {
        self.service = service
        keychain = Keychain(service: service)
    }
    
    private func save(_ data: Data, forKey: String) throws {
        do {
            try keychain.set(data, key: forKey)
        } catch let error {
            throw error
        }
    }
    
    public func save(_ data: String, forKey: String) throws {
        do {
            guard let data = data.data(using: .utf8) else {
                throw KeychainError.errorEncoding
            }
            try save(data, forKey: forKey)
        } catch let error {
            throw error
        }
    }
    
    private func retrieve(key: String) throws -> Data {
        do {
            guard let data = try keychain.getData(key) else {
                throw KeychainError.errorRetrieving
            }
            return data
        } catch let error {
            throw error
        }
    }
    
    public func retrieve(key: String) throws -> String {
        do {
            let data: Data = try retrieve(key: key)
            guard let dataString = String(data: data, encoding: .utf8) else {
                throw KeychainError.errorDecoding
            }
            return dataString
        } catch let error {
            throw error
        }
    }
    
    public func remove(key: String) throws {
        try keychain.remove(key)
    }
    
    public func removeAll() throws {
        try keychain.allKeys().forEach { (key) in
            try keychain.remove(key)
        }
    }
    
    public func has(key: String) -> Bool {
        return keychain.allKeys().contains(key)
    }
}

public enum KeychainError: Error {
    case errorEncoding
    case errorRetrieving
    case errorDecoding
}
