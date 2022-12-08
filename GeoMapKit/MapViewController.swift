//
//  ViewController.swift
//  GeoMapKit
//
//  Created by Shalopay on 06.12.2022.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    let locationManager = CLLocationManager()
    let modelUser = ModelUser()
    
    private lazy var mapView: MKMapView = {
        let mapKit = MKMapView(frame: .zero)
        mapKit.translatesAutoresizingMaskIntoConstraints = false
        mapKit.mapType = .satellite
        mapKit.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(MKAnnotationView.self))
        mapKit.delegate = self
        return mapKit
    }()
    
    private lazy var removeButton: UIButton = {
        let removeButton = UIButton(type: .system)
        
        removeButton.setImage(UIImage(systemName: "eyes")?.withRenderingMode(.alwaysTemplate), for: .normal)
        removeButton.clipsToBounds = true
        removeButton.backgroundColor = .lightGray
        removeButton.layer.cornerRadius = 30
        removeButton.addTarget(self, action: #selector(removeAnnotation), for: .touchUpInside)
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        return removeButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "КАРТА"
        modelUser.addAnnotaion(in: mapView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationEnable()
    }
    
    private func setupView() {
        view.addSubview(mapView)
        mapView.addSubview(removeButton)
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            removeButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 40),
            removeButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -40),
            removeButton.heightAnchor.constraint(equalToConstant: 60),
            removeButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func checkLocationEnable() {
        guard CLLocationManager.locationServicesEnabled()  else {
            showCustomALertLocation(title: "У Вас отключенна служба геолокации", message: "Хотите включить?", url: URL(string: "App-Prefs:root=LOCATION_SERVICES"))
            return
        }
            setupLocalManager()
            checkAuthorization()
    }
    
    private func setupLocalManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    private func checkAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .denied:
            showCustomALertLocation(title: "Вы запретили использовать местоположение", message: "Хотите это изменить?", url: URL(string: UIApplication.openSettingsURLString))
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("restricted")
            break
        @unknown default:
            break
        }
    }
    @objc func removeAnnotation() {
        print(#function)
        mapView.removeAnnotations(modelUser.users)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 4000, longitudinalMeters: 4000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR didfailtWithError: \(error)")
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? User else { return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier:NSStringFromClass(MKAnnotationView.self))!
        annotationView.annotation = annotation
        
        let newImage = qwerty(image: annotation.image)
        annotationView.image = newImage
        annotationView.canShowCallout = true
        annotationView.calloutOffset = CGPoint(x: 0, y: 10)
        
        let ageLabel = UILabel()
        ageLabel.text = String(annotation.age)
        annotationView.detailCalloutAccessoryView = ageLabel
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let coordinate = locationManager.location?.coordinate else { return }
        mapView.removeOverlays(mapView.overlays)
        let user = view.annotation as! User
        let startPoint = MKPlacemark(coordinate: coordinate)
        let endPoint = MKPlacemark(coordinate: user.coordinate)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startPoint)
        request.destination = MKMapItem(placemark: endPoint)
        request.transportType = .automobile
        let direction = MKDirections(request: request)
        direction.calculate { (response, error) in
            if let error = error {
                print("ERROR direction request: \(error)")
            }
            guard let response = response else { return }
            for route in response.routes {
                mapView.addOverlay(route.polyline)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 5
        return renderer
    }
}
