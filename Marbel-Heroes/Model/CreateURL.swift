//
//  CreateMd5Data.swift
//  MarvelHeroFinder
//
//  Created by Kevin Martinez on 3/19/22.
//

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

struct CreateURL {
    
   static func createURL() -> String {

                let ts = String(Date().timeIntervalSince1970)
                func MD5(string: String) -> Data {
                     let length = Int(CC_MD5_DIGEST_LENGTH)
                     let messageData = string.data(using:.utf8)!
                     var digestData = Data(count: length)

                     _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
                         messageData.withUnsafeBytes { messageBytes -> UInt8 in
                             if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                                 let messageLength = CC_LONG(messageData.count)

                                 CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)

                             }
                             return 0
                         }
                     }
                     return digestData
                 }

                let md5Data = MD5(string:"\(ts)\(Secrets.MarvelKeys.privateKey)\(Secrets.MarvelKeys.publickey)")
                let hash =  String(md5Data.map { String(format: "%02hhx", $0) }.joined())

                let url = "https://gateway.marvel.com/v1/public/characters?ts=\(ts)&apikey=\(Secrets.MarvelKeys.publickey)&hash=\(hash)"

                return url
            }
         
}
