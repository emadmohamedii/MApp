//
//  CharactersThumbnailModel.swift
//  MApp
//
//  Created by Emad Habib on 16/09/2023.
//

import Foundation

struct CharactersThumbnailModel : Codable {
    
    let ext : String?
    let path : String?
    var fullImage :String?
    
    
    enum CodingKeys: String, CodingKey {
        case ext = "extension"
        case path = "path"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ext = try values.decodeIfPresent(String.self, forKey: .ext)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        if let path = path , let ext = ext {
            fullImage = path + "." + ext
        }
    }
 
    init(image:String){
        self.fullImage = image
        self.ext = ""
        self.path = ""
    }
}


