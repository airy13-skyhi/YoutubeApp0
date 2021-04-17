//
//  ProfileViewController.swift
//  YoutubeApp0
//
//  Created by Manabu Kuramochi on 2021/04/17.
//

import UIKit
import Photos
import FirebaseFirestore


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var userName = String()
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button: UIButton!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 10
        textView.layer.cornerRadius = 10
        button.layer.cornerRadius = 10

        checkCamera()
    }
    
    
    @IBAction func tap(_ sender: Any) {
        
        showAlert()
    }
    
    //タッチされた時に呼ばれる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        textView.resignFirstResponder()
    }
    
    
    
    func checkCamera() {
        
        PHPhotoLibrary.requestAuthorization { (status) -> Void in
            
            switch(status) {
            
            case .authorized:
                print("Authorized")
            case .notDetermined:
                print("NotDetermined")
            case .restricted:
                print("Restricted")
            case .denied:
                print("Denied")
            case .limited:
                print("limited")
            @unknown default:break
                
            }
        }
    }
    
    
    func showAlert() {
        
        let alert: UIAlertController = UIAlertController(title: "選択してください", message: "カメラアルバムどちらにしますか？", preferredStyle: .alert)
        
        let cameraAction: UIAlertAction = UIAlertAction(title: "カメラ", style: .default) { (action: UIAlertAction!) -> Void in
            
            
            self.createImagePicker(sourceType: .camera)
        }
        
        let albumAction: UIAlertAction = UIAlertAction(title: "アルバム", style: .default) { (action: UIAlertAction!) -> Void in
            
            
            self.createImagePicker(sourceType: .photoLibrary)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(albumAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func createImagePicker(sourceType: UIImagePickerController.SourceType) {
        
        let cameraPicker = UIImagePickerController()
        cameraPicker.sourceType = sourceType
        cameraPicker.delegate = self
        cameraPicker.allowsEditing = true
        self.present(cameraPicker, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.editedImage] as? UIImage {
            
            imageView.image = pickedImage
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func done(_ sender: Any) {
        
        
        
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
