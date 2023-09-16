//
//  AppDelegate.swift
//  MApp
//
//  Created by Emad Habib on 15/09/2023.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    var appDependency: AppDependency?
    let disposeBag = DisposeBag()

    
    private var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setRootController()
        return true
    }
}

extension AppDelegate {
    func setRootController(){
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        var coreData = CoreDataStack(modelName: "MApp")
        appDependency = AppDependency(window: window!,
                                      managedContext: coreData.managedObjectContext)
        let rootViewModel = CharactersViewModel(dependencies: appDependency!)
        let rootViewController = CharactersVC()
        rootViewController.viewModel = rootViewModel
        navigationController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
}
