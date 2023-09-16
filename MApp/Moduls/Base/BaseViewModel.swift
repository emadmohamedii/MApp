//
//  BaseViewModel.swift
//  SHTask
//
//  Created by Emad Habib on 28/10/2022.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel {
    let disposeBag = DisposeBag()
    let alertDialog = PublishSubject<(String,String)>()
    
    
}
