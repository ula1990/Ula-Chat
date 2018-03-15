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
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewMessage))
        navigationItem.rightBarButtonItem?.tintColor = .black

        checkIfUserIsLoggedIn()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        observerMessages()
    }
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    func observerMessages(){
        
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{

                let message = Message()
                message.toId = dictionary["toId"] as? String
                message.text = dictionary["text"] as? String
                message.timestamp = dictionary["timestamp"] as? NSNumber
                message.fromId = dictionary["fromId"] as? String

 
//                self.messages.append(message)
                if let toId = message.toId {
                     self.messagesDictionary[toId] = message
                        self.messages = Array(self.messagesDictionary.values)
                    
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        
                        return message1.timestamp!.intValue > message2.timestamp!.intValue
                    })
                }
               
 
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }, withCancel: nil)
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let message = messages[indexPath.row]
        
        cell.message  = message

        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    

    
    @objc func handleNewMessage(){
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
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
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.navigationItem.title = dictionary["name"] as? String
                
                let user = User()
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                self.setupNavBarWithUser(user: user)
            }
        })
        
    }
    
    func setupNavBarWithUser(user: User){
     //   self.navigationItem.title = user.name
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImgageUrl = user.profileImageUrl {
            profileImageView.loadimagesUisingCacheWithUrlString(urlString: profileImgageUrl)
        }
        
        containerView.addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
 

        self.navigationItem.titleView = titleView
   /*     let recongonizer = UITapGestureRecognizer(target: self, action: #selector(MesssagesController.showChatController))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(recongonizer) */
    }
    
    @objc func showChatController(user: User){
     
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
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

