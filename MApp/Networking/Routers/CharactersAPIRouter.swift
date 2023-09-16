//
//  CharactersAPIRouter.swift
//  MApp
//

import Foundation
import Alamofire
import RxAlamofire

enum CharactersAPIRouter:URLRequestConvertible {
    
    case characters(limit:Int,offset:Int)
    case character_comics(characterId:Int)
    
    func asURLRequest() throws -> URLRequest {
        
        var method: Alamofire.HTTPMethod {
            switch self {
            case.characters,.character_comics:
                return .get
            }
        }
        
        let params: Parameters? = {
            switch self {
            case .characters,.character_comics:
                return nil
            }
        }()
        
        let url: URL = {
            // Add base url for the request
            let baseURL:String = {
                return Environment.APIBasePath(server: .generalApi)
            }()
            
            // build up and return the URL for each endpoint
            let relativePath: String = {
                switch self {
                case.characters(let limit,let offset):
                    return "characters\(Environment.APIKEY())&limit=\(limit)&offset=\(offset)"
                case.character_comics(let characterId):
                    return "characters/\(characterId)/comics\(Environment.APIKEY())"
                }
            }()
            
            let url = URL(string: encodeUrlWithApiKey(base: baseURL+relativePath))!
            return url
        }()
        
        let encoding:ParameterEncoding = {
            return JSONEncoding.default
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = Environment.defaultHeader()
        return try encoding.encode(urlRequest, with: params)
    }
}
