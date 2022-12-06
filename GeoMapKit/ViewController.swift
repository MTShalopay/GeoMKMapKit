//
//  ViewController.swift
//  GeoMapKit
//
//  Created by Shalopay on 06.12.2022.
//

import UIKit
import MapKit
/*
 48.78065345071297,44.77954825769442
 */

class ViewController: UIViewController {
    private var usersAnnotation = [MKAnnotation]()
    
    private lazy var mapView: MKMapView = {
        let mapKit = MKMapView(frame: .zero)
        mapKit.translatesAutoresizingMaskIntoConstraints = false
        mapKit.mapType = .hybrid
        return mapKit
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "Карта"
        setupView()
        mapView.addAnnotations(usersAnnotation)
    }
    
    private func setupView() {
        view.addSubview(mapView)
        setupMapView()
        createUsersAnnotation()
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func setupMapView() {
        let centerCoordinate = CLLocationCoordinate2D(latitude: 48.78065345071297,
                                                       longitude: 44.77954825769442)
        mapView.setCenter(centerCoordinate, animated: true)
        let region = MKCoordinateRegion(center: centerCoordinate,
                                        latitudinalMeters: 700,
                                        longitudinalMeters: 700)
        mapView.setRegion(region, animated: true)
        mapView.regionThatFits(region)
    }
    private func createUsersAnnotation() {
        let user1 = UserAnnotation(coordinate: CLLocationCoordinate2D(latitude: 48.78065345071297, longitude: 44.77954825769442),
                                   title: "Shalopay",
                                   subtitle: "Maxim 23")
        usersAnnotation.append(user1)
    }


}

