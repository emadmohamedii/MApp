//
//  CharDetailResponseModel.swift
//  MApp
//
//  Created by Emad Habib on 16/09/2023.
//

import Foundation

struct CharDetailResponseModel : Codable {
    let data : CharDetailDataModel?
    enum CodingKeys: String, CodingKey {
        case data
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data =  try values.decodeIfPresent(CharDetailDataModel.self, forKey: .data)
    }
}


struct CharDetailDataModel : Codable {
    let results : [CharDetailResultModel]?

    enum CodingKeys: String, CodingKey {
        case results = "results"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decodeIfPresent([CharDetailResultModel].self, forKey: .results)
    }
}


struct CharDetailResultModel : Codable {
    
    let id : Int?
    let thumbnail : CharactersThumbnailModel?
    let title : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case thumbnail
        case title = "title"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        thumbnail = try values.decodeIfPresent(CharactersThumbnailModel.self, forKey: .thumbnail)
        title = try values.decodeIfPresent(String.self, forKey: .title)
    }
    
    init(model: ComicsCoredataModel){
        self.id = Int(model.id)
        self.title = model.name
        self.thumbnail = CharactersThumbnailModel(image: model.thumbnail)
    }
    
}
