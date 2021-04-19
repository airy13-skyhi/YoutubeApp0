//
//  VideoCell.swift
//  YoutubeApp0
//
//  Created by Manabu Kuramochi on 2021/04/18.
//

import UIKit
import SDWebImage

class VideoCell: UITableViewCell {
    
    
    @IBOutlet weak var thumnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        
        
    }
    
    
    
    
}
