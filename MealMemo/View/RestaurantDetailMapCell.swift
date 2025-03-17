//
//  RestaurantDetailMapCell.swift
//  MealMemo
//
//  Created by Vincent Hunter on 3/16/25.
//

import UIKit
import MapKit

class RestaurantDetailMapCell: UITableViewCell {
    
    @IBOutlet var mapView: MKMapView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mapView.layer.cornerRadius = 20.0
        mapView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(location: String) {
        //get location
        let geoCoder = CLGeocoder()
        
        print(location)
        geoCoder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let placemarks = placemarks {
                //Get the first placemark
                
                let placemark = placemarks[0]
                
                
                //Add the annotation
                let annotation = MKPointAnnotation()
                
                if let location = placemark.location {
                    //Display the annotation
                    
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    
                    //Sets the zoom level
                    let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
                    self.mapView.setRegion(region, animated: false)
                }
            }
        }
        
    }

}
