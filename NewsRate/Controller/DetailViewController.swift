//
//  DetailViewController.swift
//  NewsRate
//
//  Created by waiyip on 21/2/2020.
//  Copyright © 2020 waiyip. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, LoadCommentsCaller {
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var commentBtn: UIBarButtonItem!
    
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let safeUrl = article?.url {
            loadPage(urlString: safeUrl)
        }
        
        self.title = article?.title
        
        article?.loadComments(caller: self)
    }
    
    func didLoadComments(comments: [Comment]) {
        if comments.count > 99 {
            commentBtn.title = "Comments (99+)"
        }
        else {
            commentBtn.title = "Comments (\(comments.count))"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    func loadPage(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("error in opening url")
            return
        }
        
        let request = URLRequest(url: url)
        
        webView?.load(request)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if segue.identifier == "goToComment" {
            let commentView = segue.destination as! CommentTableViewController
            
            commentView.article = article
        }
        
    }
    
    
    
    
}
