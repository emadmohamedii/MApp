//
//  CharactersResultModel.swift
//  MApp
//
//  Created by Emad Habib on 16/09/2023.
//

import Foundation
struct CharactersResultModel : Codable {
    
    let descriptionField : String?
    let id : Int?
    let modified : String?
    let name : String?
    let resourceURI : String?
    let thumbnail : CharactersThumbnailModel?
    
    
    enum CodingKeys: String, CodingKey {
        case descriptionField = "description"
        case id = "id"
        case modified = "modified"
        case name = "name"
        case resourceURI = "resourceURI"
        case thumbnail
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        modified = try values.decodeIfPresent(String.self, forKey: .modified)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        resourceURI = try values.decodeIfPresent(String.self, forKey: .resourceURI)
        thumbnail = try values.decodeIfPresent(CharactersThumbnailModel.self, forKey: .thumbnail)
    }
    
    init(model: CharactersCoredataModel){
        self.id = Int(model.id)
        self.name = model.title
        self.thumbnail = CharactersThumbnailModel(image: model.imageURL)
        self.resourceURI = ""
        self.modified = ""
        self.descriptionField = ""
    }
    
}

