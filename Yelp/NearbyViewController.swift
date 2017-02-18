//
//  NearbyViewController.swift
//  Yelp
//
//  Created by Ryan Liszewski on 2/17/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class NearbyViewController: UIViewController, UISearchBarDelegate {

    
    var searchBar : UISearchBar = UISearchBar()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
