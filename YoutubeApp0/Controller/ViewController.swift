//
//  ViewController.swift
//  YoutubeApp0
//
//  Created by Manabu Kuramochi on 2021/04/16.
//

import UIKit
import FirebaseAuth


class ViewController: UIViewController {
    
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var button: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.layer.cornerRadius = 10
        
        
        
    }
    
    
    
    @IBAction func createNewUser(_ sender: Any) {
        
        
        
    }
    
    func createUser() {
        //1
        
        Auth.auth().signInAnonymously { (result, error) in
           //3
            
            let user = result?.user
            print(user.debugDescription)
            
            
        }
        //2
        
    }
    
    
    
    
    
    
}

