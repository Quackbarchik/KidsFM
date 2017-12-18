//
//  ProfileVC.swift
//  KidsFM
//
//  Created by Zakhar Rudenko on 12.12.2017.
//  Copyright © 2017 Zakhar Rudenko. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData


class LoginVC: UIViewController {

    @IBOutlet weak var loginTFLogin: UITextField!
    @IBOutlet weak var passwordTFLogin: UITextField!
    let profileVC = ProfileVC()
    
    override func viewDidLayoutSubviews() {
        
        loginTFLogin.attributedPlaceholder = NSAttributedString(string: "Логин", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        passwordTFLogin.attributedPlaceholder = NSAttributedString(string: "Пароль", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        let border = CALayer();                                 let border1 = CALayer()
        let width = CGFloat(2.0);                               let width1 = CGFloat(2.0)

        border.borderColor = UIColor.darkGray.cgColor;          border1.borderColor = UIColor.darkGray.cgColor
                                        //пишу как хочу - законом не запрещено
        border.frame = CGRect(x: 0, y: loginTFLogin.frame.size.height - width, width:  loginTFLogin.frame.size.width, height: loginTFLogin.frame.size.height)
        
        border1.frame = CGRect(x: 0, y: passwordTFLogin.frame.size.height - width1, width:  passwordTFLogin.frame.size.width, height: passwordTFLogin.frame.size.height)
        
        border.borderWidth = width;                 border1.borderWidth = width
        loginTFLogin.layer.addSublayer(border);     passwordTFLogin.layer.addSublayer(border1)
        loginTFLogin.layer.masksToBounds = true;    passwordTFLogin.layer.masksToBounds = true
  
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func enterProfileAction(_ sender: Any) {
        
        if let text = loginTFLogin.text, !text.isEmpty{
            print(text.count)
            
        }

        if let name = loginTFLogin.text, let pass = passwordTFLogin.text{
            requestUserToServer(name: name, pass: pass)
        }
        
        
    }
    
    func requestUserToServer(name: String, pass: String){
        
        let param: Parameters = ["login":"\(name)","password":"\(pass)"]
        
        Alamofire.request("http://radiokids.fm/wp-json/wise-api/v2/user/get", method: .post, parameters: param).responseJSON { response in
            
            switch response.result{
            case .success:
                if let notJSON = response.result.value {
                    let json = JSON(notJSON)
                    if let checkID = Int(json["id"].stringValue){
                        switch checkID {
                            case 0:
                                print(Int(json["id"].stringValue)!)
                                let alertController = UIAlertController(title: "Ошибка", message: "Возможно ошибка в логине и/или пароле", preferredStyle: .alert)
                                let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
                                alertController.addAction(cancelAction)
                                self.present(alertController, animated: true, completion: nil)
                            
                            default:
                                self.saveData(id: json["id"].stringValue, name: json["name"].stringValue, nickname: json["nickname"].stringValue, email: json["email"].stringValue, avatar: json["avatar"].stringValue)
                                
                                let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as UIViewController
                               
                                self.present(secondViewController, animated: true, completion: nil)
                            
                        }
                    }
                }
            case .failure:
                break
            }
        }
    }
    
    func saveData(id: String, name: String, nickname: String, email: String,avatar: String){
        
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let user = User(context: context)
        
        user.id = id
        user.name = name
        user.nickname = nickname
        user.email = email
        user.avatar = avatar
        
        appDelegate.saveContext()
        Profile.user = user
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
}
