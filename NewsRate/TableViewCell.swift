//
//  TableViewCell.swift
//  NewsRate
//
//  Created by waiyip on 20/2/2020.
//  Copyright © 2020 waiyip. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var article: Article?
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateInfo() {
        if let a = article {
            titleLbl.text = a.title
            if let safeUrl = a.imgUrl {
                if ImageMemo.dict[safeUrl] != nil {
                    imgView.image = ImageMemo.dict[safeUrl]
                }
                else {
                    let url = URL(string: safeUrl)
                    let data = try? Data(contentsOf: url!)
                    if let safeData = data {
                        imgView.image = UIImage(data: safeData)
                        ImageMemo.dict[safeUrl] = imgView.image
                    }
                    
                }
                
                
            }
        }
    }
    
}
