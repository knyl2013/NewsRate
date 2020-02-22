//
//  DetailViewController.swift
//  NewsRate
//
//  Created by waiyip on 21/2/2020.
//  Copyright © 2020 waiyip. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, LoadCommentsCaller, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var commentBtn: UIBarButtonItem!
    
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let safeUrl = article?.url {
            loadPage(urlString: safeUrl)
        }
        
        self.title = article?.title
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.yellow]
        
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        article?.loadComments(caller: self)
                
        webView.navigationDelegate = self
    }
    
    func didLoadComments(comments: [Comment]) {
        if comments.count > 99 {
            commentBtn.title = "Comments (99+)"
        }
        else {
            commentBtn.title = "Comments (\(comments.count))"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    func loadPage(urlString: String) {
        let newUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        guard let url = URL(string: newUrl) else {
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
