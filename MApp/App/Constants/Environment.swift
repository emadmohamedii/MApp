//
//  Environment.swift
//  MovieApp
//



import Foundation
import Alamofire

enum Server {
    case generalApi
}

class Environment {
    
    static let debug:Bool  =  false
    static let appInfoDebug:Bool  =  false
    
    class func APIBasePath(server:Server) -> String {
        switch server {
        case .generalApi:
            return "https://gateway.marvel.com:443/v1/public/"
        }
    }
    
    class func defaultHeader() -> HTTPHeaders {
        return [.contentType("application/json")]
    }
    
    class func APIKEY()->String
    {
        let ts = String(Date().timeIntervalSince1970)
        let hash = "\(ts)\(Keys.marvelPrivateKey.rawValue)\(Keys.marvelPublicKey.rawValue)".md5Value
        var base_Key = ""
        base_Key += "?apikey=\(Keys.marvelPublicKey.rawValue)"
        base_Key += "&hash=\(hash)"
        base_Key += "&ts=\(ts)"
        return base_Key
    }
    
}
