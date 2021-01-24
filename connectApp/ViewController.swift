//
//  ViewController.swift
//  connectApp
//
//  Created by Maddy Wang on 1/15/21.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, UISearchBarDelegate{

    @IBOutlet weak var Map: MKMapView!
    
    @IBAction func searchButton(_ sender: Any) {
        
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    //allows user to search for location and find it (no direction functionality in first iteration)
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Ignore user
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Activity indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        //Hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //Create search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil{
                print("ERROR")
            }
            else {
                // removes annotations
//                let annotations = self.Map.annotations
//                self.Map.view.removeAnnotations(annotations)
                
                //getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //Create annotation
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                self.Map.addAnnotation(annotation)
                
                //zoom in on annotation
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let searchSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let searchRegion = MKCoordinateRegion(center: coordinate, span: searchSpan)
                self.Map.setRegion(searchRegion, animated: true)
            }
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // current location function is static and returns same locations for first iteration
        
        //annotation of user's location and one friend location
        let location = CLLocationCoordinate2D(latitude: 37.871666, longitude: -122.272781)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        Map.setRegion(region, animated: true)
        
        let yourLocationAnnotation = MKPointAnnotation()
        yourLocationAnnotation.coordinate = location
        yourLocationAnnotation.title = "Your location"
        
        Map.addAnnotation(yourLocationAnnotation)
        
        let nearestFriendLocation = CLLocationCoordinate2D(latitude: 37.8680, longitude: -122.2682)
        
        let nearestFriendAnnotation = MKPointAnnotation()
        nearestFriendAnnotation.coordinate = nearestFriendLocation
        nearestFriendAnnotation.title = "Avery's Location"
        nearestFriendAnnotation.subtitle = "0.6 miles away"
        
        Map.addAnnotation(nearestFriendAnnotation)
        
        
    }
    
    // takes new user to onboarding process
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if Core.shared.isNewUser() {
            //show onboarding
            let vc = storyboard?.instantiateViewController(identifier: "welcome") as! WelcomeViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
        
    }

}

class Core {
    
    static let shared = Core()
    
    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    // func called after welcome pages are filled out or user dismisses welcome page
    ///
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
        
    }
    
}
