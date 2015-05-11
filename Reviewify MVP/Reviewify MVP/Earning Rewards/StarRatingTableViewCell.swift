//
//  StarRatingTableViewCell.swift
//  Speakeasy
//
//  Created by Bryce Langlotz on 5/11/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit

protocol StarRatingTableViewCellDelegate {
    func starRatingDidChange(rating:Float!, sender:StarRatingTableViewCell!)
}

class StarRatingTableViewCell: UITableViewCell, ASStarRatingViewDelegate {
    
    @IBOutlet var starRatingView:ASStarRatingView!
    
    var delegate:StarRatingTableViewCellDelegate?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func starRatingDidChange(rating: Float) {
        self.delegate?.starRatingDidChange(rating, sender: self)
    }
}
