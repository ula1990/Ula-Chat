//
//  Message.swift
//  UlaChat
//
//  Created by Uladzislau Daratsiuk on 2018-03-15.
//  Copyright © 2018 Uladzislau Daratsiuk. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    var fromId : String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    
    func chatPartnerId() -> String?{
        return (fromId == Auth.auth().currentUser?.uid ? toId : fromId)
        
        
    }

}
