//
//  Article.swift
//  NewsRate
//
//  Created by waiyip on 20/2/2020.
//  Copyright © 2020 waiyip. All rights reserved.
//

import Foundation
import Firebase

protocol LoadCommentsCaller {
    func didLoadComments(comments: [Comment])
}

class Article {
    
    
    let description: String?
    let source: String?
    let title: String?
    let url: String?
    let imgUrl: String?
    let publishedAt: String?
    var lastScore: Int = 0
    var publishedAtDate: Date?
    
    let dictName = "voteHistory"
    
    let collectionName = "articleScore"
    
    let commentCollectionName = "articleComments"
    
    let senderField = "sender"
    
    let messageField = "message"
    
    let sentDateField = "sentDate"
    
    let db = Firestore.firestore()
    
    var delegate: TableViewCell?
    
    var history: [String:String] = [:]
    
    var lastCommentCount: Int = 0
    
    var hash: String?
    

    
    init(description: String?, source: String?, title: String?, url: String?, imgUrl: String?, publishedAt: String?) {
        self.description = description
        self.source = source
        self.title = title
        self.url = url
        self.imgUrl = imgUrl
        self.publishedAt = publishedAt
        
        if let p = publishedAt {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            self.publishedAtDate = dateFormatter.date(from:p)!
        }
        
        if let h = UserDefaults.standard.dictionary(forKey: dictName) as? [String : String] {
            history = h
        }
        else {
            UserDefaults.standard.set(history, forKey: dictName)
        }
        
    }
    
    func getTitleHash() -> String {
        if let safeHash = hash {
            return safeHash
        }
        else {
            hash = API.hash(string: getTitle())
            return hash!
        }
    }
    
   
    func addComment(caller: CommentTableViewController, msg: String) {
        var res: [Comment] = []
        
        let doc = db.collection(commentCollectionName).document(getTitleHash())
        
        doc.getDocument { (querySnapshot, error) in
            if let e = error {
                print(e)
            }
            else {
                if let data = querySnapshot?.data() as? [String : [[String:String]]] {
                    if data[self.getTitleHash()] == nil {
                        doc.setData([self.getTitleHash() : [[String:String]]()])
                    }
                    else {
                        if var safeCommentArr = data[self.getTitleHash()] {
                            safeCommentArr.append([ self.senderField: API.randEmoji(),
                                                    self.messageField: msg,
                                                    self.sentDateField: API.fromDateToString(date: Date())])
                            
                            for comment in safeCommentArr {
                                res.append(Comment(sender: comment[self.senderField]!, message: comment[self.messageField]!, sentDate: comment[self.sentDateField]!))
                            }
                            
                            doc.setData([self.getTitleHash() : safeCommentArr])
                            
                            self.lastCommentCount = safeCommentArr.count
                            
                            caller.didAddComment(comments: res)
                        }
                        else {
                            doc.setData([self.getTitleHash() : [[String:String]]()])
                        }
                    }
                }
                else {
                    doc.setData([self.getTitleHash() : [[String:String]]()])
                }
            }
        }
    }
    
    func loadComments(caller: LoadCommentsCaller) {
        var res: [Comment] = []
        
        let doc = db.collection(commentCollectionName).document(getTitleHash())
        
        doc.getDocument { (querySnapshot, error) in
            if let e = error {
                print(e)
            }
            else {
                if let data = querySnapshot?.data() as? [String : [[String:String]]] {
                    if data[self.getTitleHash()] == nil {
                        doc.setData([self.getTitleHash() : [[String:String]]()])
                    }
                    else {
                        if let safeCommentArr = data[self.getTitleHash()] {
                            for comment in safeCommentArr {
                                res.append(Comment(sender: comment[self.senderField]!, message: comment[self.messageField]!, sentDate: comment[self.sentDateField]!))
                            }
                            
                            self.lastCommentCount = safeCommentArr.count
                            
                            caller.didLoadComments(comments: res)
                        }
                        else {
                            doc.setData([self.getTitleHash() : [[String:String]]()])
                        }
                    }
                }
                else {
                    doc.setData([self.getTitleHash() : [[String:String]]()])
                }
            }
        }
        
        
    }
    
    func loadScore(tableSource: ViewController) {
        var curScore: Int = 0
        
        let doc = db.collection(collectionName).document(getTitleHash())
                
        doc.getDocument { (querySnapshot, error) in
            if let e = error {
                print(e)
            }
            else {
                if let data = querySnapshot?.data() as? [String: Int] {
                    if data[self.getTitleHash()] == nil {
                        doc.setData([self.getTitleHash() : 0])
                    }
                    else {
                        curScore = data[self.getTitleHash()]!
                    }
                }
                else {
                    doc.setData([self.getTitleHash() : 0])
                }
            }
            
            doc.setData([self.getTitleHash() : curScore])
            
            self.delegate?.showScore(score: curScore)
            
            self.lastScore = curScore
            
            tableSource.reloadTable()
        }
    }
    
    func loadScore() {
        var curScore: Int = 0
        
        let doc = db.collection(collectionName).document(getTitleHash())
                
        doc.getDocument { (querySnapshot, error) in
            if let e = error {
                print(e)
            }
            else {
                if let data = querySnapshot?.data() as? [String: Int] {
                    if data[self.getTitleHash()] == nil {
                        doc.setData([self.getTitleHash() : 0])
                    }
                    else {
                        curScore = data[self.getTitleHash()]!
                    }
                }
                else {
                    doc.setData([self.getTitleHash() : 0])
                }
            }
            
            doc.setData([self.getTitleHash() : curScore])
            
            self.delegate?.showScore(score: curScore)
            
            self.lastScore = curScore
        }
    }
    
    func getTimeAgo() -> String {

        // From Time
        let fromDate = self.publishedAtDate!

        // To Time
        let toDate = Date()

        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }

        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }

        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }

        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }

        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }

        return "a moment ago"
    }

    func getTitle() -> String {
        return title ?? "No title"
    }
    
    func upVote() {
        var curScore: Int = 0
        
        let doc = db.collection(collectionName).document(getTitleHash())
                
        doc.getDocument { (querySnapshot, error) in
            if let e = error {
                print(e)
            }
            else {
                if let data = querySnapshot?.data() as? [String: Int] {
                    curScore = data[self.getTitleHash()]!
                }
                else {
                    doc.setData([self.getTitleHash() : 0])
                }
            }
            
            curScore += 1
            
            doc.setData([self.getTitleHash() : curScore])
            
            self.delegate?.showScore(score: curScore)
            
            self.history[self.getTitleHash()] = "up"
            
            UserDefaults.standard.set(self.history, forKey: self.dictName)
            
            self.lastScore = curScore
            
            self.delegate?.updateInfo()
        }
        
    }
    
    
    func downVote() {
        var curScore: Int = 0
        
        let doc = db.collection(collectionName).document(getTitleHash())
                
        doc.getDocument { (querySnapshot, error) in
            if let e = error {
                print(e)
            }
            else {
                if let data = querySnapshot?.data() as? [String: Int] {
                    curScore = data[self.getTitleHash()]!
                }
                else {
                    doc.setData([self.getTitleHash() : 0])
                }
            }
            
            curScore -= 1
            
            doc.setData([self.getTitleHash() : curScore])
            
            self.delegate?.showScore(score: curScore)
            
            self.history[self.getTitleHash()] = "down"
            
            UserDefaults.standard.set(self.history, forKey: self.dictName)
            
            self.lastScore = curScore
            
            self.delegate?.updateInfo()
        }
    }
}
