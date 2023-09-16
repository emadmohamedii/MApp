//
//  URLRequestConvertibleExtra.swift
//  MApp
//
//  Created by Emad Habib on 15/09/2023.
//

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG
import CryptoKit
import Alamofire

extension URLRequestConvertible {
    func encodeUrlWithApiKey(base:String) -> String
    {
        return base.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}

extension String {
    var md5Value: String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)

        if let d = self.data(using: .utf8) {
            _ = d.withUnsafeBytes { body -> String in
                CC_MD5(body.baseAddress, CC_LONG(d.count), &digest)

                return ""
            }
        }

        return (0 ..< length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
}

