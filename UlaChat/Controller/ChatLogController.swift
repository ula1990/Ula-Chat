//
//  ChatLogController.swift
//  UlaChat
//
//  Created by Uladzislau Daratsiuk on 2018-03-06.
//  Copyright © 2018 Uladzislau Daratsiuk. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChatLogController: UICollectionViewController,UITextFieldDelegate {
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
        }
    }
    
        lazy var inputTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "Enter message..."
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.delegate = self
    return textField
}()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        collectionView?.backgroundColor = .white
        setupInputComponets()

    }
    
    
    func setupInputComponets(){
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitleColor(.black, for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
     
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    @objc func handleSend(){
        
        let ref  = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user?.id
        let fromID = Auth.auth().currentUser!.uid
        let timeStamp = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let values = ["text": inputTextField.text!, "toId": toId, "fromId": fromID, "timestamp": timeStamp] as [String : Any] 
        childRef.updateChildValues(values)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }

}
