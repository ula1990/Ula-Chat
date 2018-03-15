//
//  UserCell.swift
//  UlaChat
//
//  Created by Uladzislau Daratsiuk on 2018-03-15.
//  Copyright © 2018 Uladzislau Daratsiuk. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    var message: Message?{
        didSet {
            if let toId = message?.toId {
                let ref = Database.database().reference().child("users").child(toId)
                print(ref)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    print(snapshot)
                    if let dictionary = snapshot.value as? [String: AnyObject]{
                            self.textLabel?.text = dictionary["name"] as? String
                        
                        if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                            
                            self.profileImageView.loadimagesUisingCacheWithUrlString(urlString: profileImageUrl)
                        }
        
                    }
                    
                }, withCancel: nil)
            }
            self.detailTextLabel?.text = message?.text
            
            if let seconds  = message?.timestamp?.doubleValue{
                        let timestampDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: timestampDate as Date)
                
            }
            
           
    
        }
        
    }
    
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
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: (self.textLabel?.centerYAnchor)!).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
     
        
        
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Has not been implemented")
    }
    
}
