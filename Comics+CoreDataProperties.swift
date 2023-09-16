//
//  Comics+CoreDataProperties.swift
//  MApp
//
//  Created by Emad Habib on 16/09/2023.
//
//

import Foundation
import CoreData
import RxDataSources
import RxCoreData


extension Comics {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comics> {
        return NSFetchRequest<Comics>(entityName: "Comics")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var thumbnail: String?
    @NSManaged public var charId: Int32

}

struct ComicsCoredataModel {
    var id: Int32
    var thumbnail: String
    var name: String
    var charId:Int32
    init(comic: ComicModel) {
        self.charId = Int32(comic.charId)
        self.id = Int32(comic.id)
        self.thumbnail = comic.image
        self.name = comic.name
    }
}

func == (lhs: ComicsCoredataModel, rhs: ComicsCoredataModel) -> Bool {
    return lhs.id == rhs.id
}

extension ComicsCoredataModel : Equatable { }

extension ComicsCoredataModel : IdentifiableType {
    typealias Identity = String
    
    var identity: Identity { return "\(id)" }
}

extension ComicsCoredataModel : Persistable {
    typealias T = NSManagedObject
    
    static var entityName: String {
        return "Comics"
    }
    
    static var primaryAttributeName: String {
        return "charId"
    }
    
    init(entity: T) {
        id = entity.value(forKey: "id") as! Int32
        thumbnail = entity.value(forKey: "thumbnail") as! String
        name = entity.value(forKey: "name") as! String
        self.charId = entity.value(forKey: "charId") as! Int32
    }
    
    func update(_ entity: T) {
        entity.setValue(id, forKey: "id")
        entity.setValue(thumbnail, forKey: "thumbnail")
        entity.setValue(name, forKey: "name")
        entity.setValue(charId, forKey: "charId")
        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
    }
    
}
