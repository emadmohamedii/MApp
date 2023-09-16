//
//  CharactersResponseModel.swift
//  MApp
//
//  Created by Emad Habib on 16/09/2023.
//

import Foundation

struct CharactersResponseModel : Codable {
    
    let data : CharactersModel?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(CharactersModel.self, forKey: .data)
    }
}
