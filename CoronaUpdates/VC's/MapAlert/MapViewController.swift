//
//  MapViewController.swift
//  CoronaUpdates
//
//  Created by POORAN SUTHAR on 11/05/20.
//  Copyright © 2020 POORAN SUTHAR. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import UserNotifications
class MapViewController: UIViewController , CLLocationManagerDelegate , MKMapViewDelegate{
    let locationManager = CLLocationManager()
    var geofanceDictionaryArray : [[String : Any]] = [["Title":"Sumerpur","Radius" : 5000.0 ,"lat" : 25.153360 ,"long" : 73.083099]
        , ["Title":"GIT" , "Radius" : 5000.0 ,"lat" : 26.788410 ,"long" : 75.835763],
          ["Title":"Pali" , "Radius" : 5000.0 ,"lat" : 25.771090 ,"long" : 73.323448],
          ["Title":"Beawar" , "Radius" : 5000.0 ,"lat" : 26.1046 ,"long" : 74.3199]]
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        mapView.userTrackingMode = .follow
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(addLocation), userInfo: nil, repeats: true)
        setupData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
            // 2. authorization were denied
        else if CLLocationManager.authorizationStatus() == .denied {
            print("Location services were previously denied. Please enable location services for this app in Settings.")
        }
            // 3. we do have authorization
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    
    @objc func addLocation(){
        guard let currentLocation = mapView.userLocation.location else {
            return
        }
        LocationsStorage.shared.saveCLLocationToDisk(currentLocation)
    }
    
    func setupData(){
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
            for dict in geofanceDictionaryArray{
                if let title = dict["Title"] as? String {
                    let regionTitle = title
                    let regionCoordinate = CLLocationCoordinate2D(latitude: (dict["lat"] as? Double)! , longitude: (dict["long"] as? Double)!)
                    let regionRadius = dict["Radius"] as? Double
                    let region  = CLCircularRegion(center: regionCoordinate, radius: regionRadius!, identifier: regionTitle)
                    locationManager.startMonitoring(for: region)
                    
                    let patientAnnotation = MKPointAnnotation()
                    patientAnnotation.coordinate = regionCoordinate
                    patientAnnotation.title  = "\(regionTitle)"
                    mapView.addAnnotation(patientAnnotation)
                    
                    let circle = MKCircle(center: regionCoordinate, radius: regionRadius!)
                    mapView.addOverlay(circle)
                }
            }
            
        }else{
            print("System can't track regions")
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circle = MKCircleRenderer(overlay: overlay)
        circle.strokeColor = .red
        circle.lineWidth = 1.0
        return circle
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let state = UIApplication.shared.applicationState
        if state == .active{
            showAlert(title: "Warning", message: "Entered In RedZone")
        }else {
            scheduleNotification(notificationType: region.identifier, body: "Entered In RedZone")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let state = UIApplication.shared.applicationState
        if state == .active{
            showAlert(title: "STAY SAFE", message: "Exited From RedZone")
        }else{
            scheduleNotification(notificationType: region.identifier, body: "Exited From RedZone")
        }
        
    }
    
    
    func scheduleNotification(notificationType: String , body : String) {
        let content = UNMutableNotificationContent()
        content.title = notificationType
        content.body = body
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func showAlert(title : String ,message : String){
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
    }
}
