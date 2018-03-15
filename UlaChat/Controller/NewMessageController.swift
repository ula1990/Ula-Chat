//
//  NewMessageController.swift
//  UlaChat
//
//  Created by Uladzislau Daratsiuk on 2018-03-05.
//  Copyright © 2018 Uladzislau Daratsiuk. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }
    
    
    func fetchUser(){
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                print(dictionary)
                let user = User()
                user.id = snapshot.key
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    @objc func handleCancel (){
        dismiss(animated: true, completion: nil)
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UserCell
        let user = users[indexPath.row]
        cell?.textLabel?.text = user.name
        cell?.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {
           cell?.profileImageView.loadimagesUisingCacheWithUrlString(urlString: profileImageUrl)
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
    var messagesController: MesssagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true){
            print("Dismiss")
            let user = self.users[indexPath.row]
            self.messagesController?.showChatController(user: user)
            
            
        }
    }
}

class UserCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(origin: CGPoint(x: 56, y: (textLabel?.frame.origin.y)!),size: CGSize(width:(textLabel?.frame.width)!,height: (textLabel?.frame.height)!))
        detailTextLabel?.frame = CGRect(origin: CGPoint(x: 56, y: (detailTextLabel?.frame.origin.y)!),size: CGSize(width:(detailTextLabel?.frame.width)!,height: (detailTextLabel?.frame.height)!))
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "photo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Has not been implemented")
    }
    
}
