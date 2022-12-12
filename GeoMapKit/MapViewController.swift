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
    private var userAnnotations = [CustomPin]()
    
    private lazy var mapView: MKMapView = {
        let mapKit = MKMapView(frame: .zero)
        mapKit.translatesAutoresizingMaskIntoConstraints = false
        mapKit.mapType = .standard
        mapKit.showsCompass = true
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
        setupLongGesture()
    }
    
    private func setupLongGesture() {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(addPin(longGesture:)))
        longGesture.minimumPressDuration = 2
        mapView.addGestureRecognizer(longGesture)
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
        guard userAnnotations.count > 0 else { return }
        userAnnotations.forEach {
            mapView.removeAnnotation($0)
            mapView.removeOverlays(mapView.overlays)
        }
        
        userAnnotations.removeAll()
    }
    
    @objc func addPin(longGesture: UILongPressGestureRecognizer) {
        guard longGesture.state == .began else { return }
        let touchPoint = longGesture.location(in: mapView)
        let newCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let customPin = CustomPin(coordinate: newCoordinate, name: "Отметка пользователя")
        userAnnotations.append(customPin)
        mapView.addAnnotation(customPin)
        
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
          let camera = MKMapCamera(lookingAtCenter: location, fromDistance: 4000, pitch: 0, heading: 0)
            mapView.setCamera(camera, animated: true)
        }
       
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR didfailtWithError: \(error)")
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let userAnnotation = annotation as? CustomPin {
            let newImage = qwerty(image: UIImage(named: "pin")!)
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(MKAnnotationView.self))!
            creatMKAnnotationView(to: annotationView, annotation: userAnnotation, imagePin: newImage)
            return annotationView
        } else {
            guard let annotationUser = annotation as? User else { return nil }
            let newImage = qwerty(image: annotationUser.image)
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier:NSStringFromClass(MKAnnotationView.self))!
            creatMKAnnotationView(to: annotationView, annotation: annotationUser, imagePin: newImage)
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let coordinate = locationManager.location?.coordinate else { return }
        mapView.removeOverlays(mapView.overlays)
        guard let user = view.annotation as? User else {
            guard let customPin = view.annotation as? CustomPin else { return }
            creatingRoute(firstPoint: coordinate, secondPoint: customPin.coordinate, transpotType: .automobile, to: mapView)
            return
        }
        creatingRoute(firstPoint: coordinate, secondPoint: user.coordinate, transpotType: .automobile, to: mapView)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 5
        return renderer
    }
    
}
