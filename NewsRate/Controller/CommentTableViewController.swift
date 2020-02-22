//
//  CommentTableViewController.swift
//  NewsRate
//
//  Created by waiyip on 22/2/2020.
//  Copyright © 2020 waiyip. All rights reserved.
//

import UIKit

class CommentTableViewController: UIViewController, UITableViewDataSource, LoadCommentsCaller {
    
    @IBOutlet weak var tableView: UITableView!
    
    var comments: [Comment] = []
    
    let identifier = "reuseCommentCellIdentifier"
    
    let cellName = "CommentTableViewCell"
    
    
    @IBOutlet weak var messageTextField: UITextField!
    
    var article: Article?
    
    override func viewDidLoad() {
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: identifier)
        
        article?.loadComments(caller: self)
        
        self.title = article?.title
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.yellow]
        
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CommentTableViewCell
        
        cell.showComment(comment: comments[indexPath.row])
        
        return cell
    }
    
    func reloadTable(comments: [Comment]) {
        self.comments = comments
        
        self.tableView.reloadData()
        
        if comments.count > 0 {
            let indexPath = IndexPath(row: comments.count - 1, section: 0)
            
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func didAddComment(comments: [Comment]) {
        reloadTable(comments: comments)
    }
    
    func didLoadComments(comments: [Comment]) {
        reloadTable(comments: comments)
    }
    
    
    @IBAction func sendBtnPressed(_ sender: UIButton) {
        
        if let msg = messageTextField.text {
            if msg != "" {
                article?.addComment(caller: self, msg: msg)
                messageTextField.text = ""
                messageTextField.endEditing(true)
                let scrollPoint = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.size.height + 100)
                self.tableView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    
}
