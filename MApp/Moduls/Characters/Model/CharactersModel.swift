//
//  CharactersModel.swift
//  MApp
//
//  Created by Emad Habib on 15/09/2023.
//

struct CharactersModel : Codable {
    
    let results : [CharactersResultModel]?

    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decodeIfPresent([CharactersResultModel].self, forKey: .results)
    }

}



