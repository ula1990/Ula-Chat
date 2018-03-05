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
        
    }
    
    @objc func handleLogout(){
        let loginControlller = LoginController()
        present(loginControlller, animated: true, completion: nil)
        
    }



}

