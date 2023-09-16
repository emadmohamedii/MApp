//
//  APIManager.swift
//  MovieApp
//


import Foundation
import RxSwift
import Alamofire
import RxAlamofire

class APIManager {
    
    static let shared:APIManager = {
        let instance = APIManager()
        return instance
    }()
    
    let sessionManager: Session
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 40
        configuration.urlCache = nil
        sessionManager = Session(configuration: configuration)
    }
    
    func requestObservable(api:URLRequestConvertible) -> Observable<DataRequest> {
        return sessionManager.rx.request(urlRequest: api)
    }
    
    func cancelAllRequests(){
        if #available(iOS 9.0, *) {
            sessionManager.session.getAllTasks { (tasks) in
                tasks.forEach{ $0.cancel() }
            }
        } else {
            sessionManager.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
                sessionDataTask.forEach { $0.cancel() }
                uploadData.forEach { $0.cancel() }
                downloadData.forEach { $0.cancel() }
            }
        }
    }
}


