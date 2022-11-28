//
//  MapsViewController.swift
//  CustomLoginDemo
//
//  Created by Hoang Nguyen  on 02/11/2022.
//  Copyright © 2022 Christopher Ching. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapsViewController: UIViewController, CLLocationManagerDelegate {

    let manager = CLLocationManager()
    let latitude:Double = 21.038249496465184
    let longtitude:Double = 105.78267104914943
    
    // Map 1 code: be2d992f971e4b5f
    // Map 2 code: ff5d98bc6d6e1847

    override func viewDidLoad() {
        super.viewDidLoad()
        print(GMSServices.openSourceLicenseInfo())

        // Set up Map
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()

        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longtitude, zoom: 16.0)
        let mapID = GMSMapID(identifier: "ff5d98bc6d6e1847")
        let mapView = GMSMapView(frame: view.frame, mapID: mapID, camera: camera)


        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        marker.title = "Hanoi"
        marker.snippet = "Vietnam"
        marker.map = mapView
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else{
            return
        }

        let coordinate = location.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longtitude, zoom: 16.0)
        let mapID = GMSMapID(identifier: "ff5d98bc6d6e1847")
        let mapView = GMSMapView(frame: view.frame, mapID: mapID, camera: camera)
        view.addSubview(mapView)

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker.title = "Hanoi"
        marker.snippet = "Vietnam"
        marker.map = mapView
    }

}


