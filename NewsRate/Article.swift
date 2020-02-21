//
//  Article.swift
//  NewsRate
//
//  Created by waiyip on 20/2/2020.
//  Copyright © 2020 waiyip. All rights reserved.
//

import Foundation
import Firebase

struct Article {
    let description: String?
    let source: String?
    let title: String?
    let url: String?
    let imgUrl: String?
    let publishedAt: String?
    
    let collectionName = "articleScore"
    
    let db = Firestore.firestore()
    
    var delegate: TableViewCell?
    
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
        }
    }
}
