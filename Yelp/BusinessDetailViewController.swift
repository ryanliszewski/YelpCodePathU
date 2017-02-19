//
//  BusinessDetailViewController.swift
//  Yelp
//
//  Created by Ryan Liszewski on 2/17/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class BusinessDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingView: UIImageView!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var numberOfReviewsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var addressLabel: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager : CLLocationManager!
    
    var business: Business! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = business.name
        descriptionLabel.text = business.categories
        distanceLabel.text = business.distance
        ratingView.setImageWith(business.ratingImageURL!)
        posterView.setImageWith(business.imageURL!)
        

        self.navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        
    
        addAnnotationAtAddress(address: business.address!, title: business.name!)

        // Do any additional setup after loading the view.
    }
    
    func addAnnotationAtAddress(address: String, title: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let coordinate = placemarks.first!.location!
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate.coordinate
                    annotation.title = title
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addressButtonTouched(_ sender: Any) {
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        
        
        if(segue.identifier == "WebViewSegue"){
            let webViewController = segue.destination as! WebViewController
            webViewController.websiteURL = business.website
           
            
        }
        
    }

}
