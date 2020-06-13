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
         
           // we give delegate to location manager to this class
           locationManager.delegate = self
           
           // accuracy of the location
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           
           // request user for location
           locationManager.requestWhenInUseAuthorization()
           
           //start updating the location of the user
           locationManager.startUpdatingLocation()
        
        //add delegate to map object
        mapObj.delegate = self
        
        // set region
        setRegion(43.39, -79.78, "Toronto", "Downtown")
        
        // long press gesture
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(addLongPressGesture))
        mapObj.addGestureRecognizer(longPress)
        
        // double tap gesture
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTap.numberOfTapsRequired = 2
        mapObj.addGestureRecognizer(doubleTap)
       }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        let latDelta: CLLocationDegrees = 0.05
        let longDelta: CLLocationDegrees = 0.05
        
        // 3 - Creating the span, location coordinate and region
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let customLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: customLocation, span: span)
              
        // 4 - assign region to map
        mapObj.setRegion(region, animated: true)
    }
 
    @objc func addLongPressGesture(gesture: UIGestureRecognizer){
        let longPress = gesture.location(in: mapObj)
        let coordinates = mapObj.convert(longPress, toCoordinateFrom: mapObj)
        addAnnotation(coordinates ,"Long Pressed" , "Location")
    }
    
    @objc func doubleTapped(gesture: UIGestureRecognizer){
        
        let touchpoint = gesture.location(in: mapObj)
        let coordinates = mapObj.convert(touchpoint, toCoordinateFrom: mapObj)
       addAnnotation(coordinates, "Double Tapped", "Location")
        

        
        
    }
    
    func setRegion(_ latitude: CLLocationDegrees, _ longitutde: CLLocationDegrees, _ title: String, _ subtitle: String){

          // 1 - Latitude and Longitude
          let latitude: CLLocationDegrees = latitude
          let longitude: CLLocationDegrees = longitutde
          
          // 2 - Delta Latitude and Delta Longitude
          let latDelta: CLLocationDegrees = 0.05
          let longDelta: CLLocationDegrees = 0.05
          
          // 3 - Creating the span, location coordinate and region
          let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
          let customLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
          let region = MKCoordinateRegion(center: customLocation, span: span)
          
          // 4 - assign region to map
          mapObj.setRegion(region, animated: true)
          
        
         //add annotation
          addAnnotation(customLocation, title, subtitle)
        
    }
    
    
    func addAnnotation(_ coordinates: CLLocationCoordinate2D, _ title: String, _ subtitle: String){
        
        removePin()
        //  add annotation
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.subtitle = subtitle
        annotation.coordinate = coordinates
        mapObj.addAnnotation(annotation)
    }

    func removePin(){
        
//        for annotation in mapObj.annotations {
//            mapObj.removeAnnotation(annotation)
//        }

        mapObj.removeAnnotations(mapObj.annotations)
    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
//
//        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
//        pinAnnotation.animatesDrop = true
//        pinAnnotation.pinTintColor =
        let pinAnnotation = mapObj.dequeueReusableAnnotationView(withIdentifier: "droppablePin") ?? MKPinAnnotationView()
        pinAnnotation.image = UIImage(named: "ic_place_2x")
        pinAnnotation.canShowCallout = true
        pinAnnotation.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return pinAnnotation
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let alert = UIAlertController(title: "Alert", message: "Your Place", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
