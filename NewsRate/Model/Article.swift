//
//  Article.swift
//  NewsRate
//
//  Created by waiyip on 20/2/2020.
//  Copyright © 2020 waiyip. All rights reserved.
//

import Foundation
import Firebase

class Article {
    
    
    let description: String?
    let source: String?
    let title: String?
    let url: String?
    let imgUrl: String?
    let publishedAt: String?
    var lastScore: Int = 0
    var publishedAtDate: Date?
    
    let collectionName = "articleScore"
    
    let db = Firestore.firestore()
    
    var delegate: TableViewCell?
    
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
        
        
    }
    
    func loadScore(tableSource: ViewController) {
        var curScore: Int = 0
        
        let doc = db.collection(collectionName).document(getTitle())
                
        doc.getDocument { (querySnapshot, error) in
            if let e = error {
                print(e)
            }
            else {
                if let data = querySnapshot?.data() as? [String: Int] {
                    if data[self.getTitle()] == nil {
                        doc.setData([self.getTitle() : 0])
                    }
                    else {
                        curScore = data[self.getTitle()]!
                    }
                }
                else {
                    doc.setData([self.getTitle() : 0])
                }
            }
            
            doc.setData([self.getTitle() : curScore])
            
            self.delegate?.showScore(score: curScore)
            
            self.lastScore = curScore
            
            tableSource.reloadTable()
        }
    }
    
    func loadScore() {
        var curScore: Int = 0
        
        let doc = db.collection(collectionName).document(getTitle())
                
        doc.getDocument { (querySnapshot, error) in
            if let e = error {
                print(e)
            }
            else {
                if let data = querySnapshot?.data() as? [String: Int] {
                    if data[self.getTitle()] == nil {
                        doc.setData([self.getTitle() : 0])
                    }
                    else {
                        curScore = data[self.getTitle()]!
                    }
                }
                else {
                    doc.setData([self.getTitle() : 0])
                }
            }
            
            doc.setData([self.getTitle() : curScore])
            
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
        
        let doc = db.collection(collectionName).document(getTitle())
                
        doc.getDocument { (querySnapshot, error) in
            if let e = error {
                print(e)
            }
            else {
                if let data = querySnapshot?.data() as? [String: Int] {
                    curScore = data[self.getTitle()]!
                }
                else {
                    doc.setData([self.getTitle() : 0])
                }
            }
            
            curScore += 1
            
            doc.setData([self.getTitle() : curScore])
            
            self.delegate?.showScore(score: curScore)
            
            self.lastScore = curScore
        }
        
    }
    
    
    func downVote() {
        var curScore: Int = 0
        
        let doc = db.collection(collectionName).document(getTitle())
                
        doc.getDocument { (querySnapshot, error) in
            if let e = error {
                print(e)
            }
            else {
                if let data = querySnapshot?.data() as? [String: Int] {
                    curScore = data[self.getTitle()]!
                }
                else {
                    doc.setData([self.getTitle() : 0])
                }
            }
            
            curScore -= 1
            
            doc.setData([self.getTitle() : curScore])
            
            self.delegate?.showScore(score: curScore)
            
            self.lastScore = curScore
        }
    }
}
