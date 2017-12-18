//
//  RegistrationVC.swift
//  KidsFM
//
//  Created by Zakhar R on 16.12.2017.
//  Copyright © 2017 Zakhar Rudenko. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController {

    @IBOutlet weak var loginTFReg: UITextField!
    @IBOutlet weak var nameTFReg: UITextField!
    @IBOutlet weak var emailTFReg: UITextField!
    @IBOutlet weak var passwordTFReg: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

    }
    
    override func viewDidLayoutSubviews() {
        
        loginTFReg.attributedPlaceholder = NSAttributedString(string: "Логин", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        nameTFReg.attributedPlaceholder = NSAttributedString(string: "Имя", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        emailTFReg.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        passwordTFReg.attributedPlaceholder = NSAttributedString(string: "Пароль", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: loginTFReg.frame.size.height - width, width:  loginTFReg.frame.size.width, height: loginTFReg.frame.size.height)
        
        let border1 = CALayer()
        let width1 = CGFloat(2.0)
        border1.borderColor = UIColor.darkGray.cgColor
        border1.frame = CGRect(x: 0, y: nameTFReg.frame.size.height - width1, width:  nameTFReg.frame.size.width, height: nameTFReg.frame.size.height)
        
        let border2 = CALayer()
        let width2 = CGFloat(2.0)
        border2.borderColor = UIColor.darkGray.cgColor
        border2.frame = CGRect(x: 0, y: emailTFReg.frame.size.height - width2, width:  emailTFReg.frame.size.width, height: emailTFReg.frame.size.height)
        
        let border3 = CALayer()
        let width3 = CGFloat(2.0)
        border3.borderColor = UIColor.darkGray.cgColor
        border3.frame = CGRect(x: 0, y: passwordTFReg.frame.size.height - width3, width:  passwordTFReg.frame.size.width, height: passwordTFReg.frame.size.height)
        
        border.borderWidth = width
        loginTFReg.layer.addSublayer(border)
        loginTFReg.layer.masksToBounds = true
        border1.borderWidth = width1
        nameTFReg.layer.addSublayer(border1)
        nameTFReg.layer.masksToBounds = true
        border2.borderWidth = width2
        emailTFReg.layer.addSublayer(border2)
        emailTFReg.layer.masksToBounds = true
        border3.borderWidth = width3
        passwordTFReg.layer.addSublayer(border3)
        passwordTFReg.layer.masksToBounds = true
        
    }
    
    

    @IBAction func registrationDoneAction(_ sender: Any) {
        
    }
    
    @IBAction func cancelRegistrationAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
