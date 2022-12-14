//
//  Extension.swift
//  GeoMapKit
//
//  Created by Shalopay on 07.12.2022.
//

import Foundation
import UIKit
import AVFoundation
import MapKit

extension UIImage {
    func colorized(color : UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context!.setBlendMode(.multiply)
        draw(in: rect)
        context!.clip(to: rect, mask: self.cgImage!)
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let colorizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return colorizedImage!
    }
}

extension UIViewController {
    func showCustomALertLocation(title: String, message: String?, url: URL?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingButton = UIAlertAction(title: "Настройки", style: .default) { (alert) in
            if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(settingButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    func qwerty(image: UIImage) -> UIImage {
        let maxSize = CGSize(width: 40, height: 40)
        let availableRect = AVFoundation.AVMakeRect(aspectRatio: image.size, insideRect: .init(origin: .zero, size: maxSize))
        let targetSize = availableRect.size
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        let resized = renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return resized
    }
}

extension MKMapViewDelegate {
    func creatingRoute(firstPoint: CLLocationCoordinate2D, secondPoint: CLLocationCoordinate2D, transpotType: MKDirectionsTransportType, to map: MKMapView) {
         let startPoint = MKPlacemark(coordinate: firstPoint)
         let endPoint = MKPlacemark(coordinate: secondPoint)
         let request = MKDirections.Request()
         request.source = MKMapItem(placemark: startPoint)
         request.destination = MKMapItem(placemark: endPoint)
         request.transportType = transpotType
         let direction = MKDirections(request: request)
         direction.calculate { (response, error) in
             if let error = error {
                 print("ERROR direction request: \(error)")
             }
             guard let response = response else { return }
             for route in response.routes {
                 map.addOverlay(route.polyline)
                 }
             }
    }
     func creatMKAnnotationView(to : MKAnnotationView, annotation: MKAnnotation, imagePin: UIImage) {
         to.annotation = annotation
         to.image = imagePin
         to.canShowCallout = true
         to.calloutOffset = CGPoint(x: 0, y: 10)
         to.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
}
