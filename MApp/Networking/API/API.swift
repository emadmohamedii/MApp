//
//  API.swift
//  MovieApp
//


import Foundation
import RxSwift
import RxAlamofire
import Alamofire

final class API {
    
    static let shared:API = {
        let instance = API()
        return instance
    }()
    private let disposeBag = DisposeBag()
    private init() {}
    
    private static func handleDataRequest(apiRouter :URLRequestConvertible? = nil,dataRequest: Observable<DataRequest>) -> Observable<(Data?,APICallError)> {
        
        if NetworkReachabilityManager()!.isReachable == false {
            return Observable<(Data?,APICallError)>.create({ (observer) -> Disposable in
                observer.on(.next((nil,.init(callStatus: .offline,message: "OFFLINE"))))
                observer.on(.completed)
                return Disposables.create()
            })
        }
        
        return Observable<(Data?,APICallError)>.create({ (observer) -> Disposable in
            dataRequest.observe(on: MainScheduler.instance).subscribe({ (event) in
                switch event {
                case .next(let dataRequest):
                    dataRequest.responseData { response in
                        guard let statusCode = response.response?.statusCode else {
                            observer.on(.next((nil,.init(callStatus: .unknown,message: response.error?.localizedDescription ?? ""))))
                            observer.on(.completed)
                            return
                        }
                        switch response.result {
                        case .success(let data):
                            observer.on(.next((data,.init(callStatus: .success,message: ""))))
                        case .failure(let error):
                            if statusCode == 401 {
                                observer.onNext((nil,.init(callStatus: .unAuth,message: error.localizedDescription)))
                            }
                            else {
                                observer.onNext((nil,.init(callStatus: .unknown,message: error.localizedDescription)))
                            }
                            observer.onCompleted()
                        }
                    }
                case .error(let error):
                    plog(error)
                    observer.onNext((nil,.init(callStatus: .unknown,message: error.localizedDescription)))
                case .completed:
                    observer.onCompleted()
                }
            })
        })
    }
    
    func regularRequest(apiRouter :URLRequestConvertible) -> Observable<APIResult<Data>> {
        return API.handleDataRequest(apiRouter: apiRouter,dataRequest:APIManager.shared.requestObservable(api: apiRouter)).map { (data,apiStatus) in
            if apiStatus.callStatus == .success {
                if let data = data {
                    return APIResult.success(value: data)
                }
                else {
                    return APIResult.failure(error: .init(callStatus: .unknown, message: "NO DATA RETURNED"))
                }
            }
            else {
                return APIResult.failure(error: apiStatus)
            }
        }
    }
    
}
