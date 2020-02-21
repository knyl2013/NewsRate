//
//  DetailViewController.swift
//  NewsRate
//
//  Created by waiyip on 21/2/2020.
//  Copyright © 2020 waiyip. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let safeUrl = urlString {
            loadPage(urlString: safeUrl)
        }
    }
    
    func loadPage(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("error in opening url")
            return
        }
        
        let request = URLRequest(url: url)
        
        webView?.load(request)
    }
    
    
}
