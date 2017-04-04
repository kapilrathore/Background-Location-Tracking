//
//  ViewController.swift
//  BackgroundLocationTracking
//
//  Created by Kapil Rathore on 04/04/17.
//  Copyright © 2017 Kapil Rathore. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var timeDuration: UILabel!
    @IBOutlet weak var timeView: UIView!
    
    var locations: [MKPointAnnotation] = []
    let newPin = MKPointAnnotation()
    var locationManager: CLLocationManager = CLLocationManager()
    var dateStart = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
        self.locationManager.allowsBackgroundLocationUpdates = true
        timeView.isHidden = true
    }
    
    @IBAction func statusChanged(_ sender: UISwitch) {
        if sender.isOn {
            // When tracking status is set to ON (Start).
            locationManager.startUpdatingLocation()
            statusText.text = "ON"
            dateStart = Date()
            timeView.isHidden = false
            timeDuration.text = "Tracking..."
            mapView.removeAnnotations(locations)
            locations.removeAll()
        } else {
            // When tracking status is set to OFF (End).
            locationManager.stopUpdatingLocation()
            statusText.text = "OFF"
            let duration = daysBetween(start: dateStart, end: Date())
            timeDuration.text = duration
            timeView.isHidden = false
            mapView.showAnnotations(self.locations, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Calculates the difference between Start and End time.
    func daysBetween(start: Date, end: Date) -> String {
        let calendar = Calendar.current
        let a = calendar.dateComponents([.day, .hour, .minute, .second], from: start, to: end)
        let timer = "\(a.hour!)h \(a.minute!)m \(a.second!)s"
        return timer
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let mostRecentLocation = locations.last else {
            return
        }
        
        // Add the annotations for all the location coordinates to self.location array and display them on the mapView simultaneously.
        let annotation = MKPointAnnotation()
        annotation.coordinate = mostRecentLocation.coordinate
        self.locations.append(annotation)
        
        // Sets the current location to the center of the screen
        let center = CLLocationCoordinate2D(latitude: mostRecentLocation.coordinate.latitude, longitude: mostRecentLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        //set region on the map
        mapView.setRegion(region, animated: true)
    }
}
