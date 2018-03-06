//
//  ViewController.swift
//  UlaChat
//
//  Created by Uladzislau Daratsiuk on 2018-03-04.
//  Copyright © 2018 Uladzislau Daratsiuk. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MesssagesController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      // let ref = Database.database().reference(fromURL: " https://ulachat-3a303.firebaseio.com/")
     //  ref.updateChildValues(["some value": 12345 ])
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewMessage))
        navigationItem.rightBarButtonItem?.tintColor = .black

        //user is not loggged in
        
        checkIfUserIsLoggedIn()
    }
    
    @objc func handleNewMessage(){
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else{
        fetchUserAndSetupNavBarTitle()
        }
    }
    
    
    func fetchUserAndSetupNavBarTitle(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.navigationItem.title = dictionary["name"] as? String
            }
        })
        
    }
    
    @objc func handleLogout(){
        do {
            
            try Auth.auth().signOut()
        }catch let logoutError {
            print(logoutError)
        }
        let loginControlller = LoginController()
        loginControlller.messagesController = self
        present(loginControlller, animated: true, completion: nil)
        
    }



}

