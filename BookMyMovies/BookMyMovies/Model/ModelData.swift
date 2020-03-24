//
//  ModelData.swift
//  BookMyMovies
//

import UIKit

class ModelData: NSObject {
    static let shared: ModelData = ModelData()
    var Title:[String] = []
    var Image:[String] = []
    var Rating:[Double] = []
    var ReleaseDate:[String] = []
    var StatusLogin: String = ""
}
