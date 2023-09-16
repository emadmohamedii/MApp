//
//  CharacterDetailViewModel.swift
//  MApp
//
//  Created by Emad Habib on 15/09/2023.
//


import Foundation
import CoreData
import RxSwift
import RxCocoa

class CharacterDetailViewModel:BaseViewModel {
    
    /// dependencies
    typealias Dependencies = HasAPI & HasCoreData
    private let dependencies: Dependencies
    
    /// Network request in progress
    let isLoading: ActivityIndicator =  ActivityIndicator()
    var sections : BehaviorRelay<[CharDetailSectionOfCustomData]> = BehaviorRelay(value: [])
    var charModel:CharactersResultModel
    var comics = BehaviorRelay<[CharDetailResultModel]>(value : [])
    
    init(dependencies: Dependencies,charModel:CharactersResultModel) {
        self.dependencies = dependencies
        self.charModel = charModel
        super.init()
        
        getCharDetailComcisRequest()
        
        comics.asObservable()
            .subscribe(onNext: { [weak self] (result) in
                guard let `self` = self else { return }
                if !result.isEmpty {
                    for model in result {
                        _ = try? dependencies.managedObjectContext?.rx.update(ComicsCoredataModel.init(comic: .init(charId: self.charModel.id ?? 0, id: model.id ?? 0,name: model.title ?? "",image: model.thumbnail?.fullImage ?? "" )))
                    }
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func getCharDetailComcisRequest(){
        guard let charId = charModel.id else {return}
        let apiRouter = CharactersAPIRouter.character_comics(characterId: charId)
        dependencies.api.regularRequest(apiRouter: apiRouter)
            .trackActivity(isLoading)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe {[weak self] (event) in
                guard let `self` = self else { return }
                switch event {
                case .next(let result):
                    switch result {
                    case .success(let data):
                        do {
                            let model = try JSONDecoder().decode(CharDetailResponseModel.self, from: data)
                            guard let results = model.data?.results else {
                                self.setHeaderValue()
                                self.getComicsFromCoreData()
                                return
                            }
                            self.comics.accept(results)
                            setHeaderValue()
                            setComicsValue(results: results)
                        } catch ( let error ) {
                            self.alertDialog.onNext((NSLocalizedString("Please try again later", comment: ""), error.localizedDescription))
                        }
                    case .failure(let error):
                        if error.callStatus == .offline {
                            self.setHeaderValue()
                            self.getComicsFromCoreData()
                        } else {
                            self.alertDialog.onNext(("Error", error.message))
                        }
                    }
                default:
                    break
                }
            }.disposed(by: disposeBag)
    }
    
    private func setHeaderValue(){
        let headerSection = CharDetailSectionOfCustomData(headerType: .header,items: [.init(name: self.charModel.name, id: self.charModel.id, image: self.charModel.thumbnail?.fullImage, desc: self.charModel.descriptionField, type: .header)])
        self.sections.add(element: headerSection)
    }
    
    private func setComicsValue(results:[CharDetailResultModel]){
        var comicsArray = [ComicModel]()
        for result in results {
            comicsArray.append(.init(charId:self.charModel.id ?? 0,id: result.id ?? 0,
                                     name: result.title ?? "",
                                     image: result.thumbnail?.fullImage ?? ""))
        }
        let comicsSection = CharDetailSectionOfCustomData(headerType: .comics,header: "Comics", items: [.init(type: .comics,comics: comicsArray)])
        self.sections.add(element: comicsSection)
    }
    
    private func getComicsFromCoreData(){
        guard let charId = self.charModel.id else {return}
        
        let fetchRequest = NSFetchRequest<Comics>(entityName: ComicsCoredataModel.entityName)
        let predicate = NSPredicate(format: "charId == \(charId)")
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = predicate
        dependencies.managedObjectContext?.rx.entities(fetchRequest: fetchRequest).asObservable()
            .subscribe(onNext: { [weak self] commics in
                guard let `self` = self else {return}
                if !commics.isEmpty {
                    var result = [CharDetailResultModel]()
                    for comic in commics {
                        result.append(.init(model: .init(comic: .init(charId:Int(comic.charId), id: Int(comic.id),
                                                                      name: comic.name ?? "",
                                                                      image: comic.thumbnail ?? ""))))
                    }
                    self.setComicsValue(results: result)
                }
                else {
                    self.alertDialog.onNext((NSLocalizedString("Please try again later", comment: ""), " NO INTERNET , NO COMICS CACHED "))
                }
            }).disposed(by: disposeBag)
    }
}
