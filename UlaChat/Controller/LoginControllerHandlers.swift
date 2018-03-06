//
//  LoginControllerHandlers.swift
//  UlaChat
//
//  Created by Uladzislau Daratsiuk on 2018-03-05.
//  Copyright © 2018 Uladzislau Daratsiuk. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @objc func handleRegister(){
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print(Error.self )
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) {(user , error ) in
            if error != nil{
                print(Error.self)
                return
            }
            guard let uid = user?.uid else {
                return
            }
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!){
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    if let profileImageUrl =  metadata?.downloadURL()?.absoluteString{
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject] )
                    }
                    
                   
        
                })
            }

        }
    }
    
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        
        let ref = Database.database().reference(fromURL: "https://ulachat-3a303.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: {(err, ref) in
            if err != nil {
                print(err)
                return
            }
            self.dismiss(animated: true, completion: nil)
            
        } )
        
    }
    
    
    @objc func handleSelectProfileImageView(){
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
