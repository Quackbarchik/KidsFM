//
//  FetchingNewsTableViewController.swift
//  KidsFM
//
//  Created by Zakhar Rudenko on 07.12.2017.
//  Copyright © 2017 Zakhar Rudenko. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftDate
import SafariServices

class FetchingNewsVC: UIViewController, SFSafariViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var news = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNews{
            self.tableView.reloadData()
        }
    }

    func getNews(complited: @escaping () -> ()){
        
        Alamofire.request("http://radiokids.fm/wp-json/wp/v2/news?orderby=date&fields=id,title,content,excerpt,date,thumbnail", method: .get).responseJSON { response in
            switch response.result{
            case .success:
                if let notJSON = response.result.value {
                    let json = JSON(notJSON)
                    let norm = json.arrayValue
                    for a in norm{
                                    self.news.append(News(id: a["id"].stringValue,
                                         title: a["title"]["rendered"].stringValue,
                                         date: a["date"].stringValue,
                                         excerpt: a["excerpt"]["rendered"].stringValue,
                                         imageNews: a["thumbnail"].stringValue,
                                         link: a["link"].stringValue))
                    }
                    DispatchQueue.main.async {
                        complited()
                    }
                }
            case .failure:
                break
            }
        }
    }
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellForNews

        cell.title.numberOfLines = 0
        cell.title.lineBreakMode = .byWordWrapping
        cell.title.sizeToFit()
        cell.title.text = news[indexPath.row].title.htmlDecoded
        
       if let date1 = DateInRegion(string: news[indexPath.row].date!,
                                 format: .iso8601(options: [.withFullDate, .withTimeZone]),
                                 fromRegion: Region(tz: TimeZoneName.europeMoscow,
                                                    cal: CalendarName.gregorian,
                                                    loc: LocaleName.russian)){
        
        let localDate = date1.toRegion(Region(tz: TimeZoneName.europeMoscow,
                                              cal: CalendarName.gregorian,
                                              loc: LocaleName.russian))
        let formatedDate = localDate.string(custom: "d MMM, hh:mm")
        
        cell.date.text = String(describing: formatedDate)
        
        }
        
        cell.newsContent.text = news[indexPath.row].excerpt.htmlDecoded
        cell.imageNews.downloadedFrom(url: URL(string: "\(news[indexPath.row].imageNews)")!)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let news = self.news[indexPath.row]
        let url = news.link
        self.showWebSite(url: url)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 430.0
    }
    
    func showWebSite(url: String){
        
        let URL = NSURL(string: url)!
        let safariVC = SFSafariViewController(url: URL as URL)
        self.present(safariVC, animated: false, completion: nil)
        
        safariVC.delegate = self

    }
}
