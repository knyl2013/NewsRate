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
