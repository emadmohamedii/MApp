//
//  BehaviorRelayX.swift
//  MApp
//
//  Created by Emad Habib on 16/09/2023.
//

import Foundation
import RxSwift
import RxCocoa

extension BehaviorRelay where Element: RangeReplaceableCollection {

    func add(element: Element.Element) {
        var array = self.value
        array.append(element)
        self.accept(array)
    }
}

