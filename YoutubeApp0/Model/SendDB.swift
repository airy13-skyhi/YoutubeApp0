//
//  SendDB.swift
//  YoutubeApp0
//
//  Created by Manabu Kuramochi on 2021/04/17.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

protocol DoneSendProfileDelegate {
    
    func doneSendProfileDelegate(sendCheck:Int)
}


class  SendDB {
    
    var userName = String()
    var imageData = Data()
    var db = Firestore.firestore()
    var doneSendProfileDelegate:DoneSendProfileDelegate?
    
    
    init() {
        
        
    }
    
    func sendProfile(userName:String, imageData:Data, profileTextView: String) {
        
        let imageRef = Storage.storage().reference().child("ProfileImageFolder").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        
        imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            imageRef.downloadURL { (url, error) in
                
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                
                self.db.collection("profile").document(userName).setData(
                
                    ["userName":userName as Any, "imageURLString":url?.absoluteString as Any, "profileTextView":profileTextView as Any]
                
                )
             
                self.doneSendProfileDelegate?.doneSendProfileDelegate(sendCheck: 1)
            }
            
        }
        
    }
    
    
    
    
    
    
}

