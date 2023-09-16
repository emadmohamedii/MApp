//
//  CharactersViewModel.swift
//  MApp
//
//  Created by Emad Habib on 15/09/2023.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa
import RxCoreData
import Alamofire

class CharactersViewModel:BaseViewModel {
    
    /// dependencies
    typealias Dependencies = HasAPI & HasCoreData
    private let dependencies: Dependencies
    
    /// Network request in progress
    let isLoading: ActivityIndicator =  ActivityIndicator()
    
    //Paging Metadata
    private let limit: Int = 20
    var nextPage: Int = 0
    var isFromCoredata: Bool = false
    
    //Method
    var callNextPage = PublishSubject<Void>()
    var chars: BehaviorRelay<[CharactersResultModel]> = BehaviorRelay(value: [])
    var getCharsData : BehaviorRelay<[CharactersResultModel]> = BehaviorRelay(value: [])
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init()
        
        getAllCharsRequest()
        
        
        self.callNextPage.asObservable().subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            // Check internet availability, call next page API if internet available
            if UtilityFunctions.isConnectedToInternet == true {
                self.nextPage += 1
                self.getAllCharsRequest()
            }
            else {
                self.getCharsFromCoreData()
            }
        }).disposed(by: disposeBag)
        
        chars.asObservable()
            .subscribe(onNext: { [weak self] (result) in
                guard let `self` = self else { return }
                if !isFromCoredata && !result.isEmpty {
                    for model in result {
                        _ = try? dependencies.managedObjectContext?.rx.update(CharactersCoredataModel.init(char: model))
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func getAllCharsRequest(){
        isFromCoredata = false
        let apiRouter = CharactersAPIRouter.characters(limit: limit, offset: self.nextPage  == 0 ? 0 : self.nextPage * limit)
        dependencies.api.regularRequest(apiRouter: apiRouter)
            .trackActivity(nextPage == 0 ? isLoading : ActivityIndicator())
            .observe(on: MainScheduler.asyncInstance)
            .subscribe {[weak self] (event) in
                guard let `self` = self else { return }
                switch event {
                case .next(let result):
                    switch result {
                    case .success(let data):
                        do {
                            let model = try JSONDecoder().decode(CharactersResponseModel.self, from: data)
                            guard let results = model.data?.results else {
                                self.getCharsFromCoreData()
                                return
                            }
                            let currentData = self.chars.value + results
                            self.chars.accept(currentData)
                        } catch ( let error ) {
                            self.alertDialog.onNext((NSLocalizedString("Please try again later", comment: ""), error.localizedDescription))
                        }
                    case .failure(let error):
                        if error.callStatus == .offline {
                            self.getCharsFromCoreData()
                        } else {
                            self.alertDialog.onNext(("Error", error.message))
                        }
                    }
                default:
                    break
                }
            }.disposed(by: disposeBag)
    }
    
    func getCharsFromCoreData(){
        isFromCoredata = true
        let fetchRequest = NSFetchRequest<CharList>(entityName: CharactersCoredataModel.entityName)
        fetchRequest.sortDescriptors = []
        fetchRequest.fetchLimit = self.limit
        fetchRequest.fetchOffset = self.nextPage
        do {
            if let charModels =  try dependencies.managedObjectContext?.fetch(fetchRequest) {
                plog(self.chars.value.count)
                plog(charModels.count)
                
                if charModels.count == 0 {
                    plog(" NO INTERNET , NO CACHED ")
                    return
                }
                var chars = [CharactersResultModel]()
                for char in charModels {
                    let charModel = CharactersResultModel.init(model: .init(entity: char))
                    // Check char object is contains in main array which bind to tableview, ignore that object
                    if self.chars.value.contains(where: { $0.id == charModel.id }) == false {
                        chars.append(CharactersResultModel.init(model: .init(char: charModel)))
                    }
                }
                
                let currentData = self.chars.value + chars
                self.chars.accept(currentData)
                self.nextPage += self.limit
            }
        }
        catch let error {
            self.alertDialog.onNext((NSLocalizedString("Please try again later", comment: ""), error.localizedDescription))
        }
    }
}
