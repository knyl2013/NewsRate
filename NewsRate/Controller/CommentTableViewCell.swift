//
//  CommentTableViewCell.swift
//  NewsRate
//
//  Created by waiyip on 22/2/2020.
//  Copyright © 2020 waiyip. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {


    @IBOutlet weak var ctView: UIView!
    
    @IBOutlet weak var senderBtn: UIButton!
    
    @IBOutlet weak var messageLbl: UILabel!
    
    @IBOutlet weak var timeAgoLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ctView.layer.borderWidth = 1
        ctView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showComment(comment: Comment) {
        messageLbl.text = comment.message
        senderBtn.setTitle(comment.sender, for: .normal)
        timeAgoLbl.text = comment.getTimeAgo()
    }
    
}
