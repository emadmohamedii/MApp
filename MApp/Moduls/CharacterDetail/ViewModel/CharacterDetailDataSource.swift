//
//  CharacterDetailDataSource.swift
//  MApp
//
//  Created by Emad Habib on 16/09/2023.
//
import Foundation
import RxDataSources

enum CharDetailSectionType:Int {
    case header
    case comics
    case series
    case stories
    case events
    case relatedLinks
    case none
}

struct CharDetailSection {
    var name:String?
    var id:Int?
    var image:String?
    var desc:String?
    var type:CharDetailSectionType
    var comics : [ComicModel]?
    var events : [ComicModel]?
    var stories : [ComicModel]?
    var series : [ComicModel]?
}

struct CharDetailSectionOfCustomData {
    var headerType :CharDetailSectionType
    var header: String = ""
    var items: [Item]
}

extension CharDetailSectionOfCustomData: SectionModelType {
    typealias Item = CharDetailSection
    init(original: CharDetailSectionOfCustomData, items: [Item]) {
        self = original
        self.items = items
    }
}

struct ComicModel {
    var charId:Int
    var id:Int
    var name:String
    var image:String
}
