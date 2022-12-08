//
//  User.swift
//  GeoMapKit
//
//  Created by Shalopay on 07.12.2022.
//

import Foundation
import UIKit
import MapKit

enum Gender: CustomStringConvertible {
    case man
    case woman
    var description: String {
        switch self {
        case .man:
            return "Парень"
        case .woman:
            return "Девушка"
        }
    }
}

class User: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let name: String
    let age: String
    let image: UIImage
    let gender: Gender
    var title: String? {
        return name
    }
    var subtitle: String? {
        return age
    }
    init(name: String, age: String, image: UIImage, gender: Gender, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.age = age
        self.image = image
        self.gender = gender
        self.coordinate = coordinate
    }
}


