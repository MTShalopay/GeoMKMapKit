//
//  ModelUser.swift
//  GeoMapKit
//
//  Created by Shalopay on 07.12.2022.
//

import Foundation
import UIKit
import MapKit
class ModelUser {
    var users = [User]()
    init() {
        createUser()
    }
    
    private func createUser() {
        let man1 = User(name: "Михаил", age: "30 лет", image: UIImage(named: "man1")!, gender: .man, coordinate: CLLocationCoordinate2D(latitude: 55.753894, longitude: 37.617518))
        let man2 = User(name: "Максим", age: "20 лет", image: UIImage(named: "man2")!, gender: .man, coordinate: CLLocationCoordinate2D(latitude: 55.756794, longitude: 37.619918))
        let man3 = User(name: "Артур", age: "40 лет", image: UIImage(named: "man3")!, gender: .man, coordinate: CLLocationCoordinate2D(latitude: 55.750094, longitude: 37.610018))
        users.append(man1)
        users.append(man2)
        users.append(man3)
        let woman1 = User(name: "Анжела", age: "40 лет", image: UIImage(named: "woman1")!, gender: .woman, coordinate: CLLocationCoordinate2D(latitude: 55.740094, longitude: 37.617518))
        let woman2 = User(name: "Анна", age: "25 лет", image: UIImage(named: "woman2")!, gender: .woman, coordinate: CLLocationCoordinate2D(latitude: 55.756794, longitude: 37.610018))
        let woman3 = User(name: "Арина", age: "20 лет", image: UIImage(named: "woman3")!, gender: .woman, coordinate: CLLocationCoordinate2D(latitude: 55.753894, longitude: 37.619918))
        let woman4 = User(name: "Мария", age: "22 лет", image: UIImage(named: "woman4")!, gender: .woman, coordinate: CLLocationCoordinate2D(latitude: 55.754094, longitude: 37.610018))
        let woman5 = User(name: "Карина", age: "19 лет", image: UIImage(named: "woman5")!, gender: .woman, coordinate: CLLocationCoordinate2D(latitude: 55.759094, longitude: 37.617518))
        users.append(woman1)
        users.append(woman2)
        users.append(woman3)
        users.append(woman4)
        users.append(woman5)
    }
    func addAnnotaion(in mapView: MKMapView) {
        for user in users {
            mapView.addAnnotation(user)
        }
    }
}
