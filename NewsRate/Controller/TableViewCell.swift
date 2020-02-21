//
//  TableViewCell.swift
//  NewsRate
//
//  Created by waiyip on 20/2/2020.
//  Copyright © 2020 waiyip. All rights reserved.
//

import UIKit
import Firebase

class TableViewCell: UITableViewCell {
    
    var article: Article?
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var upBtn: UIButton!
    
    @IBOutlet weak var downBtn: UIButton!
    
    @IBOutlet weak var scoreLbl: UILabel!
    
    @IBOutlet weak var timeAgoLbl: UILabel!
    
    @IBOutlet weak var ctView: UIView!
    
    let db = Firestore.firestore()
    
    let collectionName = "articleScore"
    
    var delegate: ViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        titleLbl.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
        titleLbl.addGestureRecognizer(tap)
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        if let a = article {
            delegate?.showDetail(article: a)
        }
    }
    
    
    
    func showScore(score: Int) {
        if score > 99 {
            scoreLbl.text = "99+"
        }
        else {
            scoreLbl.text = "\(score)"
        }
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
        timeAgoLbl.text = article?.getTimeAgo()
        article?.delegate = self
        article?.loadScore()
    }
    
    
    @IBAction func upBtnPressed(_ sender: UIButton) {
        upBtn.tintColor = .green
        
        article?.upVote()
    }
    
    
    @IBAction func downBtnPressed(_ sender: UIButton) {
        downBtn.tintColor = .red
        
        article?.downVote()
    }
    
}
