//
//  NearbyViewController.swift
//  Yelp
//
//  Created by Ryan Liszewski on 2/17/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class NearbyViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

   
    @IBOutlet weak var categoryTableView: UITableView!
    
    var searchBar : UISearchBar = UISearchBar()
    var category: String!
    
    
    var categories: [String]! = ["Restaurants", "Bars", "Coffee"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.tableFooterView = UIView()
        categoryTableView.sizeToFit()
        
        print("test")
        self.navigationItem.titleView = searchBar
        self.searchBar.searchBarStyle = .prominent
        self.searchBar.placeholder = "Search"
        searchBar.delegate = self
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.768627451, green: 0.07058823529, blue: 0, alpha: 1)
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return categories.count
        
      
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier:"CategoryCell", for: indexPath) as! CategoryCell
        
        cell.categoryLabel.text = categories![indexPath.row]
        cell.selectionStyle = .none
    
        return cell
    }
    
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        self.searchBar.showsCancelButton = true
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
            }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
        
        
        let businessViewController = self.storyboard?.instantiateViewController(withIdentifier: "BusinessViewController") as! BusinessesViewController
        businessViewController.category = searchBar.text
        self.navigationController?.pushViewController(businessViewController, animated: true)
        
    }


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        let viewController = segue.destination as! BusinessesViewController
        
        let cell = sender as! UITableViewCell
        let indexPath = categoryTableView.indexPath(for: cell)
        let category = categories[indexPath!.row]
        viewController.category = category
        
    }
    
    

}
