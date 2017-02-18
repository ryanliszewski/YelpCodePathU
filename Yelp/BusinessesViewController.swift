//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var mapView: MKMapView!
    
    
    var locationManager : CLLocationManager!
    var currentView: UIView!
    
    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    
    var searchBar: UISearchBar = UISearchBar()
    
    var isMoreDataLoading = false
    
    var offset: Int? = 0
    var limit: Int? = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        mapView.delegate = self
 
        self.navigationItem.titleView = searchBar
        self.searchBar.searchBarStyle = .prominent
        self.searchBar.placeholder = "Restuarant"
        searchBar.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        let selectedColor = #colorLiteral(red: 0.768627451, green: 0.07058823529, blue: 0, alpha: 1)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: selectedColor], for: .selected)
        
        
        
        
        //let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        
        //goToLocation(centerLocation)
        loadTableView()
        yelpSearch()
        
        
    

        

        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
    func yelpSearch(){
        Business.searchWithTerm(term: "Indian", completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.filteredBusinesses = self.businesses
            
            if let businesses = businesses {
                for business in businesses {
                    self.tableView.reloadData()
                    
                    print(business.name!)
                    print(business.address!)
                }
            }
        })
    }
    
    
    
    @IBAction func changeViewType(_ sender: UIBarButtonItem) {
        
        if currentView == self.tableView   {
           print("loading map view")
            loadMapView()
            
        } else if currentView == self.mapView {
            print("loading table view")
            loadTableView()
            print(currentView)
        }
    }
    
    func loadMapView(){
        
        UIView.transition(from: self.tableView, to: self.mapView, duration: 0.3, options: .transitionFlipFromTop, completion: nil)
        currentView = self.mapView
        populateMapView()
    }
    
    func loadTableView() {
        UIView.transition(from: self.mapView, to: self.tableView, duration: 0.3, options: .transitionFlipFromBottom, completion: nil)
        self.tableView.reloadData()
        currentView = self.tableView
    }
    
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true
            
        }
    }
    
    func populateMapView(){
        
        for business in filteredBusinesses {
            addAnnotationAtAddress(address: business.address!, title: business.name!)
        }
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
    
    
    
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customAnnotationView"
      
        //users location 
        if annotation is MKUserLocation{
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        else {
            annotationView!.annotation = annotation
        }
        annotationView!.pinColor = MKPinAnnotationColor(rawValue: UInt(GL_RED))!
        
        return annotationView
    }
    
    
    
    
    func loadMoreData(){
        
        self.offset! = self.offset! + 20
        Business.searchWithTerm(term: "food", sort: YelpSortMode(rawValue: 0) , categories: [], limit: limit, deals: false, offset: offset, completion: { (businesses: [Business]?, error: Error? ) -> Void in
            
            
            self.businesses.append(contentsOf: businesses!)
            
            
            self.filteredBusinesses = self.businesses
            self.isMoreDataLoading = false
            
            if let businesses = businesses {
                for business in businesses {
                    //self.tableView.reloadData()
                    
                    print(business.name!)
                    print(business.address!)
                }
            }

            self.tableView.reloadData()
            
        })
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            print("help")
            return filteredBusinesses.count
        } else {
            print("error")
            return 0
        }
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"BusinessCell", for: indexPath)
            as! BusinessCell
        
        cell.business = filteredBusinesses[indexPath.row]
        
        return cell
    }
    
    
    
    
    
    
    /*
        SEARCH FUNCTIONS
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredBusinesses = searchText.isEmpty ? businesses : businesses!.filter({(business: Business) -> Bool in
            
            return (business.name!).range(of: searchText, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        self.searchBar.showsCancelButton = true
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.filteredBusinesses = businesses
        self.tableView.reloadData()
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
    }
   
    
    /*
        SCROLLVIEW
     
    */
    
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        if(!isMoreDataLoading){
            
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging){
                print("test")
                isMoreDataLoading = true
                loadMoreData()
            }
        }
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let business = filteredBusinesses[indexPath!.row]
        
        let viewController = segue.destination as! BusinessDetailViewController
        
        viewController.business = business
        
     }
    
    
}
