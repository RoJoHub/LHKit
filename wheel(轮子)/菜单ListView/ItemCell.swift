//
//  ItemCell.swift
//  Glassmania
//
//  Created by LH-Mac on 2017/3/30.
//  Copyright © 2017年 LuoHao. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var arrowImgView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        arrowImgView.image=UIImage.pngFromBundle(with: "arrow_gray_right")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
