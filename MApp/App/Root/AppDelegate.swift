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
        setDefaults()
        setRootController()
        
        return true
    }
}

import SDWebImage

extension AppDelegate {
    private func setDefaults(){
        SDImageCache.shared.config.maxDiskAge = 3600 * 24 * 7 // 1 Week
        SDImageCache.shared.config.maxMemoryCost = 1024 * 1024 * 4 * 20 // 20 images (1024 * 1024 pixels)
        SDImageCache.shared.config.diskCacheReadingOptions = .mappedIfSafe // Use mmap for disk cache query
        SDWebImageManager.shared.optionsProcessor = SDWebImageOptionsProcessor() { url, options, context in
            // Disable Force Decoding in global, may reduce the frame rate
            var mutableOptions = options
            mutableOptions.insert(.avoidDecodeImage)
            return SDWebImageOptionsResult(options: mutableOptions, context: context)
        }
    }
    
    func setRootController(){
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let coreData = CoreDataStack(modelName: "MApp")
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
