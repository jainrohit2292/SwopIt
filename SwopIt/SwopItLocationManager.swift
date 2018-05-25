//
//  SwopItLocationManager.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 3/2/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import CoreLocation

class SwopItLocationManager: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    static var swopItLocManager: SwopItLocationManager?
    
    static func getInstance()-> SwopItLocationManager{
        if(swopItLocManager ==  nil){
            swopItLocManager = SwopItLocationManager()
        }
        return swopItLocManager!
    }
    
    func requestLocationUpdate(){
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        Utils.saveLocationToPrefs(loc: locValue)
    }
}
