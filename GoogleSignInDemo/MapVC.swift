//
//  MapVC.swift
//  GoogleSignInDemo
//
//  Created by Jayaram G on 14/01/19.
//  Copyright © 2019 Jayaram G. All rights reserved.
import UIKit
import Foundation
import CoreLocation
import GoogleMaps
import GooglePlaces
import MapKit
class MapVC: UIViewController,CLLocationManagerDelegate {
        @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
    }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last! as CLLocation
        let lat = location.coordinate.latitude
        print(lat)
        let long = location.coordinate.longitude
    }
    }
    

    
    
   

