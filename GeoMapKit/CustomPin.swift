//
//  CustomPin.swift
//  GeoMapKit
//
//  Created by Shalopay on 08.12.2022.
//

import Foundation
import MapKit

class CustomPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var name: String
    var title: String? {
        return name
    }
    var subtitle: String? {
        return "\(coordinate.latitude) \(coordinate.longitude)"
    }
    init(coordinate: CLLocationCoordinate2D, name: String) {
        self.coordinate = coordinate
        self.name = name
    }
}
