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
    
    var sortBy = "time"
    
    var country: String = "hk"
    
    @IBOutlet weak var countryBtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTable.dataSource = self
        
        newsTable.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        requestInfo()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    func showDetail(article: Article) {
        let detailViewController =  self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        detailViewController.article = article
            
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TableViewCell
        
        cell.article = self.articles[indexPath.row]
        
        cell.updateInfo()
        
        cell.delegate = self
        
        return cell
    }
    
    func reloadTable() {
        switch sortBy {
            case "time":
                articles.sort { (a, b) -> Bool in
                    return a.publishedAtDate! > b.publishedAtDate!
                }
            case "time-rev":
                articles.sort { (a, b) -> Bool in
                    return a.publishedAtDate! < b.publishedAtDate!
                }
            case "rate":
                articles.sort { (a, b) -> Bool in
                    return a.lastScore > b.lastScore
                }
            case "rate-rev":
                articles.sort { (a, b) -> Bool in
                    return a.lastScore < b.lastScore
                }
            default:
                print("Error: Unknown sorting method - \(sortBy)")
        }
        
        
        newsTable.reloadData()
    }
    
    @IBAction func sortBtnPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "How to sort", message: "Choose a sorting method", preferredStyle: .alert)
        
        let sortByTime = UIAlertAction(title: "Latest" + ((sortBy == "time") ? "(Current)" : ""), style: .default) { (action:UIAlertAction!) in
            self.sortBy = "time"
            self.reloadTable()
        }
        
        alertController.addAction(sortByTime)
                
        let sortByRate = UIAlertAction(title: "Hottest" + ((sortBy == "rate") ? "(Current)" : ""), style: .default) { (action:UIAlertAction!) in
            self.sortBy = "rate"
            self.reloadTable()
        }
        
        alertController.addAction(sortByRate)
    
        
        self.present(alertController, animated: true) {
            self.reloadTable()
        }
    }
    
    @IBAction func reloadBtnPressed(_ sender: UIBarButtonItem) {
        requestInfo()
    }
    
    func addCountryBtn(title: String, label: String, alertController: UIAlertController) {
        alertController.addAction(UIAlertAction(title: title, style: .default) {
            (action:UIAlertAction!) in
                self.countryBtn.title = title
                self.country = label
                self.requestInfo()
        })
    }
    
    @IBAction func countryBtnPressed(_ sender: UIBarButtonItem) {
            let alertController = UIAlertController(title: "What news to show", message: "Choose a country", preferredStyle: .alert)
            
            addCountryBtn(title: "🇭🇰 Hong Kong", label: "hk", alertController: alertController)
        
            addCountryBtn(title: "🇺🇸 United States", label: "us", alertController: alertController)
        
            addCountryBtn(title: "🇯🇵 Japan", label: "jp", alertController: alertController)
            
            addCountryBtn(title: "🇦🇺 Australia", label: "au", alertController: alertController)
            
            self.present(alertController, animated: true) {
                self.reloadTable()
            }
    }
    
    func requestInfo() {
        let parameters : [String:String] = [
            "country" : country,
            "apiKey" : "d807696ae35941f689cb56b0e696e1a5"
        ]
        
        AF.request(URL(string: newsURL)!, method: .get, parameters: parameters)
        .validate()
        .responseJSON { response in
            switch response.result {
            case .success(let _):
                do {
                    self.articles = []
                    
                    self.newsTable.reloadData()
                    
                    let json = try JSON(data: response.data!)
                    
                    let len: Int = json["articles"].count
                
                    
                    for i in 0..<len {
                        let newArticle: Article = Article(description: json["articles"][i]["description"].string,
                                                          source: json["articles"][i]["source"]["name"].string,
                                                          title: json["articles"][i]["title"].string,
                                                          url: json["articles"][i]["url"].string,
                                                          imgUrl: json["articles"][i]["urlToImage"].string,
                                                          publishedAt: json["articles"][i]["publishedAt"].string)
                        
                        newArticle.loadScore(tableSource: self)
                        
                        self.articles.append(newArticle)
                    }
                    
                    self.reloadTable()
                    
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

