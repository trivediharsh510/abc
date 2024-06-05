//
//  EncryptionHelper.swift
//  PassWordManager
//
//  Created by HARSH TRIVEDI on 05/06/24.
//

import Foundation
import CommonCrypto

class EncryptionHelper {
    static func encrypt(text: String, key: String) -> String? {
        if let data = text.data(using: .utf8), let encryptedData = encrypt(data: data, key: key) {
            return encryptedData.base64EncodedString()
        }
        return nil
    }
    
    static func decrypt(encryptedText: String, key: String) -> String? {
        if let data = Data(base64Encoded: encryptedText), let decryptedData = decrypt(data: data, key: key) {
            return String(data: decryptedData, encoding: .utf8)
        }
        return nil
    }
    
    private static func encrypt(data: Data, key: String) -> Data? {
        return performCryptoOperation(data: data, key: key, operation: kCCEncrypt)
    }
    
    private static func decrypt(data: Data, key: String) -> Data? {
        return performCryptoOperation(data: data, key: key, operation: kCCDecrypt)
    }
    
    private static func performCryptoOperation(data: Data, key: String, operation: Int) -> Data? {
        let keyLength = kCCKeySizeAES256
        var keyBytes = Data(count: keyLength)
        keyBytes.withUnsafeMutableBytes { keyBytes in
            _ = key.data(using: .utf8)?.copyBytes(to: keyBytes)
        }
        
        let dataLength = data.count
        let bufferSize = dataLength + kCCBlockSizeAES128
        var buffer = Data(count: bufferSize)
        var numBytesProcessed = 0
        
        let cryptStatus = buffer.withUnsafeMutableBytes { bufferBytes in
            data.withUnsafeBytes { dataBytes in
                keyBytes.withUnsafeBytes { keyBytes in
                    CCCrypt(
                        CCOperation(operation),
                        CCAlgorithm(kCCAlgorithmAES128),
                        CCOptions(kCCOptionPKCS7Padding),
                        keyBytes.baseAddress,
                        keyLength,
                        nil,
                        dataBytes.baseAddress,
                        dataLength,
                        bufferBytes.baseAddress,
                        bufferSize,
                        &numBytesProcessed
                    )
                }
            }
        }
        
        if cryptStatus == kCCSuccess {
            buffer.count = numBytesProcessed
            return buffer
        }
        
        return nil
    }
}

