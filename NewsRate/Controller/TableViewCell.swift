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
    
    let dictName = "voteHistory"
    
    var delegate: ViewController?
    
    var history: [String: String] = [:]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        reloadVoteHistory()
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
    
    func reloadVoteHistory() {
        if let h = UserDefaults.standard.dictionary(forKey: dictName) as? [String : String] {
            history = h
        }
        else {
            UserDefaults.standard.set(history, forKey: dictName)
            history = [:]
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
            
            reloadVoteHistory()
            
            if history[a.getTitle()] == nil {
                upBtn.tintColor = .lightGray
                downBtn.tintColor = .lightGray
            }
            else if history[a.getTitle()] == "up" {
                upBtn.tintColor = .green
            }
            else if history[a.getTitle()] == "down" {
                downBtn.tintColor = .red
            }
            
        }
    
        
        timeAgoLbl.text = article?.getTimeAgo()
        article?.delegate = self
        article?.loadScore()
    }
    
    
    @IBAction func upBtnPressed(_ sender: UIButton) {
        if let ti = article?.getTitle() {
            if history[ti] == nil {
                article?.upVote()
            }
        }
    }
    
    
    @IBAction func downBtnPressed(_ sender: UIButton) {
        if let ti = article?.getTitle() {
            if history[ti] == nil {
                article?.downVote()
            }
        }
    }
    
}
