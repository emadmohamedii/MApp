//
//  APICallError.swift
//  MovieApp
//

import Foundation

enum APICallStatus: Error ,Equatable{
    case success
    case failed
    case forbidden
    case serializationFailed
    case offline
    case timeout
    case unknown
    case unAuth
}

class APICallError {
    var message:String = ""
    var code:Int = -1
    var callStatus: APICallStatus = .unknown
    
    init(callStatus: APICallStatus , message:String){
        self.message = message
        self.callStatus = callStatus
    }
}
