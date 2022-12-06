//
//  UserAnnotation.swift
//  GeoMapKit
//
//  Created by Shalopay on 07.12.2022.
//

import Foundation
import MapKit

class UserAnnotation: NSObject, MKAnnotation {
    internal var coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    internal let title: String?
    internal let subtitle: String?
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
