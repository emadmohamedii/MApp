//
//  CharList+CoreDataProperties.swift
//  MApp
//
//  Created by Emad Habib on 16/09/2023.
//
//

import Foundation
import CoreData
import RxDataSources
import RxCoreData


extension CharList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharList> {
        return NSFetchRequest<CharList>(entityName: "CharList")
    }

    @NSManaged public var desc: String?
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var thumbnail: String?

}

struct CharactersCoredataModel {
    var id: Int32
    var imageURL: String
    var title: String
    var desc:String
    init(char: CharactersResultModel) {
        self.id = Int32(char.id ?? 0)
        self.imageURL = char.thumbnail?.fullImage ?? ""
        self.title = char.name ?? ""
        self.desc = char.descriptionField ?? ""
    }
}

func == (lhs: CharactersCoredataModel, rhs: CharactersCoredataModel) -> Bool {
    return lhs.id == rhs.id
}

extension CharactersCoredataModel : Equatable { }

extension CharactersCoredataModel : IdentifiableType {
    typealias Identity = String
    
    var identity: Identity { return "\(id)" }
}

extension CharactersCoredataModel : Persistable {
    typealias T = NSManagedObject
    
    static var entityName: String {
        return "CharList"
    }
    
    static var primaryAttributeName: String {
        return "id"
    }
    
    init(entity: T) {
        id = entity.value(forKey: "id") as! Int32
        imageURL = entity.value(forKey: "thumbnail") as! String
        title = entity.value(forKey: "name") as! String
        desc = entity.value(forKey: "desc") as! String
    }
    
    func update(_ entity: T) {
        entity.setValue(id, forKey: "id")
        entity.setValue(imageURL, forKey: "thumbnail")
        entity.setValue(title, forKey: "name")
        entity.setValue(desc, forKey: "desc")

        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
    }
    
}

