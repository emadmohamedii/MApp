//
//  UtilityFunctions.swift
//  FilGoalIOS
//
//  Created by Apple on 13/01/2021.
//  Copyright © 2021 Sarmady. All rights reserved.
//
import UIKit
import Foundation
import Alamofire

class UtilityFunctions: NSObject {
    
    class var isConnectedToInternet:Bool
    {
        return NetworkReachabilityManager()!.isReachable
    }
}


