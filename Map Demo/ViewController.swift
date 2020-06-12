//
//  ViewController.swift
//  Map Demo
//
//  Created by Anmol singh on 2020-06-12.
//  Copyright © 2020 Swift Project. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
       
    @IBOutlet weak var mapObj: MKMapView!
    override func viewDidLoad() {
           super.viewDidLoad()
           // Do any additional setup after loading the view.
         /*
           // we give delegate to location manager to this class
           locationManager.delegate = self
           
           // accuracy of the location
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           
           // request user for location
           locationManager.requestWhenInUseAuthorization()
           
           //start updating the location of the user
           locationManager.startUpdatingLocation()
           */
        
        // 1 - Latitude and Longitude
        let latitude: CLLocationDegrees = 43.64
        let longitude: CLLocationDegrees = -79.38
        
        // 2 - Delta Latitude and Delta Longitude
        let latDelta: CLLocationDegrees = 0.05
        let longDelta: CLLocationDegrees = 0.05
        
        // 3 - Creating the span, location coordinate and region
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let customLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: customLocation, span: span)
        
        // 4 - assign region to map
        mapObj.setRegion(region, animated: true)
       }
/*
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
    }
 */
}

