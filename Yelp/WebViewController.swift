//
//  WebViewController.swift
//  Yelp
//
//  Created by Ryan Liszewski on 2/18/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var websiteURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(websiteURL)
        
        let requestURL = URL(string: websiteURL)

        let request = URLRequest(url: requestURL!)
        
        webView.loadRequest(request)
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
