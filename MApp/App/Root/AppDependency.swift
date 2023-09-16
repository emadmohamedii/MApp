//
//  AppDependency.swift
//  SHTask
//
//  Created by Emad Habib on 28/10/2022.
//

import Foundation
import UIKit
import CoreData

protocol HasWindow {
    var window: UIWindow { get }
}

protocol HasAPI {
    var api: API { get }
}

protocol HasCoreData {
    var managedObjectContext: NSManagedObjectContext? {get}
}

class AppDependency: HasWindow, HasAPI, HasCoreData {
    
    let window: UIWindow
    let api: API
    let managedObjectContext: NSManagedObjectContext?
    
    init(window: UIWindow, managedContext: NSManagedObjectContext?) {
        self.window = window
        self.api = API.shared
        self.managedObjectContext = managedContext
    }
}
