//
//  CharacterDetailComicsViewModel.swift
//  MApp
//
//  Created by Emad Habib on 16/09/2023.
//

import Foundation
import RxCocoa
import RxSwift

final class CharacterDetailComicsViewModel {
    
    //MARK:- Output
    private let _items = BehaviorRelay<[ComicModel]>(value: [])
    lazy var items = _items.asDriver(onErrorJustReturn: [])
    
    private let comictsList: [ComicModel]
    
    
    init(comictsList: [ComicModel]) {
        self.comictsList = comictsList
    }
    
    func fetchData() {
        var items = [ComicModel]()
        
        comictsList.forEach { position in
            items.append(position)
        }
        _items.accept(items)
    }
}
