//
//  AboutUsVC.swift
//  KidsFM
//
//  Created by Zakhar Rudenko on 14.12.2017.
//  Copyright © 2017 Zakhar Rudenko. All rights reserved.
//

import UIKit
import SafariServices

class AboutUsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var social = [Social]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        dataAdd {
            self.tableView.reloadData()
        }
    }
    
    func dataAdd(complited: @escaping () -> ()) {
        
        social.append(Social(logo: #imageLiteral(resourceName: "youtube-symbol"), name: "Youtube", link: "https://www.youtube.com/channel/UCYhyHb9tmpYwzeYFSu3Ty0Q"))
        social.append(Social(logo: #imageLiteral(resourceName: "instagram-logo"), name: "Instagram", link: "https://www.instagram.com/radiokidsfm"))
        social.append(Social(logo: #imageLiteral(resourceName: "vkontakte-logo"), name: "Вконтакте", link: "https://vk.com/radiokidsfm"))
        social.append(Social(logo: #imageLiteral(resourceName: "odnoklassniki-logo"), name: "Одноклассники", link: "https://ok.ru/radiokidsfm"))
        
        social.append(Social(logo: nil, name: "Перейти на сайт", link: "http://radiokids.fm/"))
        social.append(Social(logo: nil, name: "Контакты", link: "http://radiokids.fm/contacts/"))
        social.append(Social(logo: nil, name: "О приложении", link: "https://xlife.moscow"))

        DispatchQueue.main.async {
            complited()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return social.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "aboutCell", for: indexPath) as! AboutUsCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.socLabel.text = social[indexPath.row].name
        cell.socImage.image = social[indexPath.row].logo
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let social = self.social[indexPath.row]
        let url = social.link
        self.showWebSite(url: url)
        
    }
    
    func showWebSite(url: String){
        
        let URL = NSURL(string: url)!
        let safariVC = SFSafariViewController(url: URL as URL)
        self.present(safariVC, animated: false, completion: nil)
        
        safariVC.delegate = self
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
