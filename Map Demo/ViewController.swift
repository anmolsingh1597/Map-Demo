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
    
    var destination: CLLocationCoordinate2D!
       // create places array
       let places = Place.getPlaces()

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
        
        /// set region
        setRegion(43.39, -79.78, "Toronto", "Downtown")
        
        // long press gesture
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(addLongPressGesture))
        mapObj.addGestureRecognizer(longPress)
        
        // double tap gesture
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTap.numberOfTapsRequired = 2
        mapObj.addGestureRecognizer(doubleTap)
        
        // add annotation for the places
        addPlaces()
        
        /// add polyline
//        addPolyline()
        
        // add polygon
        addPolygon()
       }
    
    //MARK:-draw direction
    
    @IBAction func drawDirection(_ sender: UIButton) {
        mapObj.removeOverlays(mapObj.overlays)
        
        let source = MKPlacemark(coordinate: locationManager.location!.coordinate)
        let destination = MKPlacemark(coordinate: self.destination)
        
        //request a direction
        let directionRequest = MKDirections.Request()
        
        //define source and destination
        directionRequest.source = MKMapItem(placemark: source)
        directionRequest.destination = MKMapItem(placemark: destination)
        
        //transportation type
        directionRequest.transportType = .automobile
        
        // calculate direction
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResponse = response else {return}
            // create route
            let route = directionResponse.routes[0]
            // draw polyline
            self.mapObj.addOverlay(route.polyline, level: .aboveRoads)
            
            // defining the bounding map react
            let rect = route.polyline.boundingMapRect
            self.mapObj.setRegion(MKCoordinateRegion(rect), animated: true)
            
            self.mapObj.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
        }
        
    }
    
    
    //MARK:- add places function
    func addPlaces() {
        mapObj.addAnnotations(places)
        
        let overlays = places.map { MKCircle(center: $0.coordinate, radius: 1000)}
        mapObj.addOverlays(overlays)
    }

    //MARK:- add polyline
    func addPolyline(){
        let locations = places.map{$0.coordinate}
        let polyline = MKPolyline(coordinates: locations, count: locations.count)
        mapObj.addOverlay(polyline)
    }
    
    //MARK:- func add polygon
    func addPolygon(){
        let locations = places.map{$0.coordinate}
        let polygon = MKPolygon(coordinates: locations, count: locations.count)
        mapObj.addOverlay(polygon)
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
        
        self.destination = coordinates
        
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

//        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
//        pinAnnotation.animatesDrop = true
//        pinAnnotation.pinTintColor =
        let pinAnnotation = mapObj.dequeueReusableAnnotationView(withIdentifier: "droppablePin") ?? MKPinAnnotationView()
        pinAnnotation.image = UIImage(named: "ic_place_2x")
        pinAnnotation.canShowCallout = true
        pinAnnotation.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return pinAnnotation
    }

    //MARK:- callout accessory
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let alert = UIAlertController(title: "Alert", message: "Your Place", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    //MARK:- render for overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let rendrer = MKCircleRenderer(overlay: overlay)
            rendrer.fillColor = UIColor.black.withAlphaComponent(0.5)
            rendrer.strokeColor = UIColor.green
            rendrer.lineWidth = 2
            return rendrer
        }else if overlay is MKPolyline {
            let rendrer = MKPolylineRenderer(overlay: overlay)
            rendrer.strokeColor = UIColor.blue
            rendrer.lineWidth = 3
            return rendrer
        }else if overlay is MKPolygon {
            let rendrer = MKPolygonRenderer(overlay: overlay)
            rendrer.fillColor = UIColor.red.withAlphaComponent(0.6)
            rendrer.strokeColor = UIColor.blue
            rendrer.lineWidth = 2
            return rendrer
        }
        
        return MKOverlayRenderer()
    }
}

//MARK:- User Defaults
/*
 
 import Cocoa

 let defaults = UserDefaults.standard

 defaults.set(24, forKey: "age")
 defaults.set(0.24, forKey: "volume")
 defaults.set(true, forKey: "isLoggedIn")
 defaults.set(Date(), forKey: "todayDate")

 let array = [1,2,3]
 defaults.set(array, forKey: "intArray")

 let dict = ["name": "Anmol", "course": "iOS"]
 defaults.set(dict, forKey: "dictValues")

 let age = defaults.integer(forKey: "age")
 let age2 = defaults.integer(forKey: "age") as Int

 let volume = defaults.float(forKey: "volume")
 let loginInfo = defaults.bool(forKey: "isLoggedIn")
 let todayDate = defaults.object(forKey: "todayDate")
 let intArray = defaults.array(forKey: "intArray")
 let dictionary = defaults.dictionary(forKey: "dictValues")

 print(age)



 
 */
