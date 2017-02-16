//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    
    var searchBar: UISearchBar = UISearchBar()
    
    var isMoreDataLoading = false
    
    var offset: Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120 
        
        self.navigationItem.titleView = searchBar
        self.searchBar.searchBarStyle = .prominent
        self.searchBar.placeholder = "Restuarant"
        searchBar.delegate = self
        
        
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
            
            }
        )
        
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
    
    
    func loadMoreData(){
        
        self.offset! = self.offset! + 20
        Business.searchWithTerm(term: "Indian", sort: .distance, categories: [], deals: false, offset: offset, completion: { (businesses: [Business]?, error: Error? ) -> Void in
            
            
            self.businesses.append(contentsOf: businesses!)
            self.filteredBusinesses = self.businesses
            self.isMoreDataLoading = false
            self.tableView.reloadData()
            
        })
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return filteredBusinesses.count
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"BusinessCell", for: indexPath) 
            as! BusinessCell
        
        
        cell.business = filteredBusinesses[indexPath.row]
        
        return cell

    }
    
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
