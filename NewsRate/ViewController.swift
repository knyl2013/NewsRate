//
//  ViewController.swift
//  NewsRate
//
//  Created by waiyip on 20/2/2020.
//  Copyright © 2020 waiyip. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

// http://newsapi.org/v2/top-headlines?country=hk&apiKey=d807696ae35941f689cb56b0e696e1a5

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var newsTable: UITableView!
    
    var articles: [Article] = []
    
    let newsURL: String = "https://newsapi.org/v2/top-headlines"
    
    let reuseIdentifier = "reuseCellIdentifier"
    
    let cellName = "TableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTable.dataSource = self
        
        newsTable.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        requestInfo()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TableViewCell
        
        cell.article = self.articles[indexPath.row]
        
        cell.updateInfo()
        
        return cell
    }
    
    func requestInfo() {
        let parameters : [String:String] = [
            "country" : "hk",
            "apiKey" : "d807696ae35941f689cb56b0e696e1a5"
        ]
        
        AF.request(URL(string: newsURL)!, method: .get, parameters: parameters)
        .validate()
        .responseJSON { response in
            switch response.result {
            case .success(let _):
                do {
                    self.articles = []
                    
                    let json = try JSON(data: response.data!)
                    
                    print(json)
                    
                    let len: Int = json["articles"].count
                
                    
                    for i in 0..<len {
                        let newArticle: Article = Article(description: json["articles"][i]["description"].string,
                                                          source: json["articles"][i]["source"]["name"].string,
                                                          title: json["articles"][i]["title"].string,
                                                          url: json["articles"][i]["url"].string,
                                                          imgUrl: json["articles"][i]["urlToImage"].string,
                                                          publishedAt: json["articles"][i]["publishedAt"].string)
                        
                        self.articles.append(newArticle)
                        
                        DispatchQueue.main.async {
                            self.newsTable.reloadData()
                        }
                    }
                    
                    
                    
                }
                catch {
                    print(error)
                }
            case .failure(let error):
                print("failed")
                print(error)
            }
        }
        
    }
    
    
    

}

