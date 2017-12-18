//
//  ViewController.swift
//  KidsFM
//
//  Created by Zakhar Rudenko on 06.12.2017.
//  Copyright © 2017 Zakhar Rudenko. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import WebKit
import Alamofire
import SwiftyJSON
import SwiftDate


class ChatAndVideoVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var chatMessages = [MessagesModel]()
    var videoPlayer = AVPlayer()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var messageTF: UITextField!
    
    
    override func viewDidAppear(_ animated: Bool){
        videoStart()
        getChatMessages {
            self.chatMessages.reverse()
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.rowHeight = 80

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        videoPlayer.pause()
        self.videoView.removeFromSuperview()
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            Profile.user = (try context.fetch(User.fetchRequest()))[0]

            let parameters: Parameters = ["ip":"0","user":"\(Profile.user?.id ?? "0")","message":"\(messageTF.text ?? "")","photo":"\(Profile.user?.avatar ?? "nil")"]

            sendMessage(parameters: parameters)
        }
        catch {
            print("Fetching Failed")
        }
  
    }
    
    func videoStart(){
        
        let videoURL = NSURL(string: "http://s2.myowntv.org/hls/radiokidsfm.m3u8")
        videoPlayer = AVPlayer(url: videoURL! as URL)
        let playerController = AVPlayerViewController()
        playerController.player = videoPlayer
        playerController.showsPlaybackControls = true
        let playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer.frame = CGRect(x:0, y:0, width: videoView.bounds.width, height: videoView.bounds.height)
        self.videoView.layer.addSublayer(playerLayer)
        videoPlayer.play()
    }
    
    func getChatMessages(complited: @escaping () -> ()){
        
        Alamofire.request("http://radiokids.fm/wp-json/wise-api/v2/messages/0", method: .get).responseJSON { response in
            switch response.result{
            case .success:
                if let notJSON = response.result.value {
                    let json = JSON(notJSON)
                    let norm = json.arrayValue
                    
                    self.chatMessages = []
                    for a in norm{
                        self.chatMessages.append(MessagesModel(time: a["time"].stringValue,
                                                           user: a["user"].stringValue,
                                                           avatarUrl: a["avatar_url"].stringValue,
                                                           text: a["text"].stringValue))
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
    
    func sendMessage(parameters: Parameters){

        Alamofire.request("http://radiokids.fm/wp-json/wise-api/v2/messages/send", method: .post, parameters: parameters).responseJSON { response in
            switch response.result{
            case .success:
                if let notJSON = response.result.value {
                    let json = JSON(notJSON)
                    let norm = json.arrayValue
                    for a in norm{
                        print(a)
                    }
                    self.getChatMessages {
                        self.chatMessages.reverse()
                        self.tableView.reloadData()
                    }
                }
            case .failure:
                break
            }
        }
    }
}

extension ChatAndVideoVC{
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! CellForChat
        let urlString = "\(chatMessages[indexPath.row].avatarUrl)"
        let url = URL(string: urlString)
        
        
        cell.nameUser.text = chatMessages[indexPath.row].user

        cell.messageUser.numberOfLines = 0
        cell.messageUser.lineBreakMode = .byWordWrapping
        cell.messageUser.sizeToFit()
        cell.messageUser.text = chatMessages[indexPath.row].text.htmlDecoded

        let myDate = Date(timeIntervalSince1970: TimeInterval(Int(chatMessages[indexPath.row].time!)!))
        let date = DateInRegion(absoluteDate: myDate)

        let localDate = date.toRegion(Region(tz: TimeZoneName.europeMoscow,
                                              cal: CalendarName.gregorian,
                                              loc: LocaleName.russian))
        let formatedDate = localDate.iso8601(opts: [.withTime])
        
        if localDate.isToday{
            cell.timeMsgUser.text = String(describing: formatedDate)
        }else if localDate.isYesterday{
            cell.timeMsgUser.text = "Вчера " + String(describing: formatedDate)
        }
        
        cell.imageUser.downloadedFrom(url: url!)
        cell.imageUser.layer.cornerRadius = 20
        
        return cell
    }
    
}
