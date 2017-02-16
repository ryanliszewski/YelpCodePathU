//
//  BusinessCell.swift
//  Yelp
//
//  Created by Ryan Liszewski on 2/13/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var profilePosterView: UIImageView!
    @IBOutlet weak var ratingView: UIImageView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var numberOfReviewsLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    var business: Business! {
        didSet {
            titleLabel.text = business.name
            distanceLabel.text = business.distance
            numberOfReviewsLabel.text = "\(business.reviewCount!)Reviews"
            categoriesLabel.text = business.categories
            addressLabel.text = business.address
            moneyLabel.text = "$$"
            
            
            profilePosterView.setImageWith(business.imageURL!)
            ratingView.setImageWith(business.ratingImageURL!)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.size.width
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePosterView.layer.cornerRadius = 3
        profilePosterView.clipsToBounds = true
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.size.width
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
