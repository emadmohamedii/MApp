//
//  Errors.swift
//  MApp
//


import Foundation

enum ListsScreenErrors {
    case noData
    case reloadAfter30Sec
    case noInternet
    case unknownError
}

enum APIStatusCodes: Int {
    case success = 200
    case unAuth = 401
    case failed
}
