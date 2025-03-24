//
//  MapViewController.swift
//  MealMemo
//
//  Created by Vincent Hunter on 3/16/25.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    var restaurant = Restaurant()

    override func viewDidLoad() {
        super.viewDidLoad()

        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location) { placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let placemarks = placemarks {
                //Get the first placemark
               let placemark = placemarks[0]
                
                //Add annotation
                let annotation = MKPointAnnotation()
                annotation.self.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    //Display the annotation
                    self.mapView.showAnnotations( [annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
                
            }
        }
        mapView.delegate = self
        
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsTraffic = true
        
        
    }
    

}

extension MapViewController : MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyMarker"
        
        if annotation.isKind(of: MKUserLocation.self) {
            
            return nil
        }
        
        //Resue the annotation if it's possible
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        annotationView?.glyphImage = UIImage(systemName: "person.circle")
        annotationView?.markerTintColor = UIColor.orange
        
        return annotationView
    }
    
    
    
}
