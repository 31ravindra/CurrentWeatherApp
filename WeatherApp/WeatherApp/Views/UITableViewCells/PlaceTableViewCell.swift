//
//  PlaceTableViewCell.swift
//  WeatherApp
//
//  Created by Ravindra Patidar on 11/07/21.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblPlaceName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setLblPlaceName(text: String) {
        self.lblPlaceName.text = text
    }
    
}
