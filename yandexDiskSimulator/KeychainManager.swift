//
//  KeychainManager.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import Foundation

class KeychainManager {
    
    enum Service: String {
        case yandex = "YandexDisk"
    }
    
    enum Account: String {
        case mikhail = "Mikhail"
    }
    
    static let shared = KeychainManager()
    
    enum KeychainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
    }
    
    func save(
        service: String,
        account: String,
        token: Data
                   ) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: token as AnyObject
        ]
            let status = SecItemAdd(
                query as CFDictionary,
                nil
            )
           
           guard status != errSecDuplicateItem else {
               throw KeychainError.duplicateEntry
           }
                       
           guard status == errSecSuccess else {
               throw KeychainError.unknown(status)
           }
                       
    }
    
    func get(service: String,
            account: String
            ) -> Data? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
            var result: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &result)
           
        
        return result as? Data
        
    }
    
    func saveTokenInKeychain(_ token: String) {
        do {
            try KeychainManager.shared.save(
                service: Service.yandex.rawValue,
                account: Account.mikhail.rawValue,
                token: token.data(using: .utf8) ?? Data()
            )
        } catch {
            print(error)
        }
    }
    
    
    func getTokenFromKeychain() -> String? {
        guard let data = KeychainManager.shared.get(service: Service.yandex.rawValue, account: Account.mikhail.rawValue) else {
            print("Failed to read token from storage")
            return nil
        }
        let token = String(decoding: data, as: UTF8.self)
        return token
    }
    
    
    private func deleteKeychainItem(searchAttributes attrs: CFDictionary, _ completion: @escaping (OSStatus) -> Void) {
        DispatchQueue.main.async {
            let result = SecItemDelete(attrs)
            completion(result)
        }
    }
    
    func delete() {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Service.yandex.rawValue as AnyObject,
            kSecAttrAccount as String: Account.mikhail.rawValue as AnyObject,
        ]
        deleteKeychainItem(searchAttributes: query as CFDictionary) { status in
            print("\(status)")
        }
    }

    
}
