//
//  FirstViewController.swift
//  day05
//
//  Created by Simon GAUDIN on 1/15/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

enum Chosen_Place
{
    case Ecole42, ChezMoiClichy, ChezMoiTarbes
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager?
    
    var placeChoice: Chosen_Place?
    
    let coordinatesHomeTarbes = CLLocationCoordinate2DMake(43.24626689999999, 0.057677300000023024)
    let coordinatesHomeClichy = CLLocationCoordinate2DMake(48.9025189, 2.3056444000000056)
    let coordinatesEcole42 = CLLocationCoordinate2DMake(48.89668380000001, 2.318375500000002)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.requestWhenInUseAuthorization()
        
        if self.placeChoice == nil
        {
            self.placeChoice = Chosen_Place.Ecole42
        }
        
        let annotationHomeTarbes = MKPointAnnotation()
        annotationHomeTarbes.title = "Tarbes"
        annotationHomeTarbes.subtitle = "Home sweet home"
        annotationHomeTarbes.coordinate = coordinatesHomeTarbes
        
        let annotationHomeClichy = MKPointAnnotation()
        annotationHomeClichy.title = "Clichy"
        annotationHomeClichy.subtitle = "Chez moi !"
        annotationHomeClichy.coordinate = coordinatesHomeClichy
        
        let annotationEcole42 = MKPointAnnotation()
        annotationEcole42.title = "Ecole 42"
        annotationEcole42.subtitle = "For the win o/"
        annotationEcole42.coordinate = coordinatesEcole42

        
        mapView.addAnnotation(annotationEcole42)
        mapView.addAnnotation(annotationHomeClichy)
        mapView.addAnnotation(annotationHomeTarbes)
        
        let regionToZoom = MKCoordinateRegionMakeWithDistance(coordinatesEcole42, 200, 200)
   
        mapView.setRegion(regionToZoom, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Updated location :D")
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation.title!! == "My Location"
        {
            return nil
        }
        
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinView")
        pinView.canShowCallout = true
        pinView.calloutOffset = CGPoint(x: -6.0, y: -6.0)
        switch annotation.title!! {
        case "Ecole 42":
            pinView.pinTintColor = UIColor.red
            break
        case "Tarbes":
            pinView.pinTintColor = UIColor.cyan
            break
        case "Clichy":
            pinView.pinTintColor = UIColor.yellow
            break
        default:
            break
        }
        return pinView
    }

    @IBAction func unWindSegue(segue: UIStoryboardSegue)
    {
        let regionToZoom: MKCoordinateRegion?
        switch self.placeChoice!
        {
            case Chosen_Place.Ecole42:
                regionToZoom = MKCoordinateRegionMakeWithDistance(coordinatesEcole42, 200, 200)
                break
            case Chosen_Place.ChezMoiClichy:
                regionToZoom = MKCoordinateRegionMakeWithDistance(coordinatesHomeClichy, 200, 200)
                break
            case Chosen_Place.ChezMoiTarbes:
                regionToZoom = MKCoordinateRegionMakeWithDistance(coordinatesHomeTarbes, 200, 200)
        }
        
        mapView.setRegion(regionToZoom!, animated: true)
    }
    
    @IBAction func changeMapStyle(_ sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex {
        case 0:
            self.mapView.mapType = .standard
            break
        case 1:
            self.mapView.mapType = .satellite
            break
        case 2:
            self.mapView.mapType = .hybrid
        default:
            break
        }
    }
    
    @IBAction func setRegionOnMe(_ sender: UIButton)
    {
        if let myCoordinates = self.locationManager?.location?.coordinate
        {
            let regionOnMe = MKCoordinateRegionMakeWithDistance(myCoordinates, 200, 200)
            mapView.setRegion(regionOnMe, animated: true)
        }
    }
    
}

