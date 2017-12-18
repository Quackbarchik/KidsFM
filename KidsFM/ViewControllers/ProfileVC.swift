//
//  ProfileVC.swift
//  KidsFM
//
//  Created by Zakhar R on 16.12.2017.
//  Copyright © 2017 Zakhar Rudenko. All rights reserved.
//

import UIKit
import CoreData


class ProfileVC: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        emailLabel.text = Profile.user?.email
        
    }
    
    
    @IBAction func changePasswordAction(_ sender: Any) {
    }
    
    @IBAction func exitFromProfileAction(_ sender: Any) {
        
        Profile.user = nil
        deleteRecords()
        print(1)
        dismiss(animated: true, completion: nil)
    }

    func deleteRecords() -> Void {
        let moc = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        let result = try? moc.fetch(fetchRequest)
        let resultData = result as! [User]
        
        for object in resultData {
            moc.delete(object)
        }
        
        do {
            try moc.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        
    }
    
    func transitionView(_ nameVC:String, delay: Double)
    {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = (mainView.instantiateViewController(withIdentifier: nameVC)) as UIViewController
        
        let window = UIApplication.shared.windows[0] as UIWindow
        UIView.transition(
            from: window.rootViewController!.view,
            to: secondViewController.view,
            duration: delay,
            options: .transitionCrossDissolve,
            completion: {
                finished in window.rootViewController = secondViewController
        })
    }
    
    // MARK: Get Context
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

}
