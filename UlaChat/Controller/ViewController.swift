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

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
      // let ref = Database.database().reference(fromURL: " https://ulachat-3a303.firebaseio.com/")
     //  ref.updateChildValues(["some value": 12345 ])
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        
        //user is not loggged in
        
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            
        }
        
    }
    
    @objc func handleLogout(){
        do {
            
            try Auth.auth().signOut()
        }catch let logoutError {
            print(logoutError)
        }
        let loginControlller = LoginController()
        present(loginControlller, animated: true, completion: nil)
        
    }



}

