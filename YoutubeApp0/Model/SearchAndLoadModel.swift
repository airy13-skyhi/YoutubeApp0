//
//  SearchAndLoadModel.swift
//  YoutubeApp0
//
//  Created by Manabu Kuramochi on 2021/04/18.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftyJSON
import Alamofire
import FirebaseAuth


protocol DonecatchDataProtocol {
    
    
    func doneCatchData(array:[DataSets])
}


protocol DoneLoadDataProtocol {
    
    func doneloadData(array:[DataSets])
    
}

protocol DoneLoadUserNameProtocol {
    
    func doneLoadUserName(array:[String])
}


class SearchAndLoadModel {
    
    var urlString = String()
    var resultPerpage = Int()
    var dataSetsArray:[DataSets] = []
    var doneCatchDataProtocol:DonecatchDataProtocol?
    var doneLoadDataProtocol:DoneLoadDataProtocol?
    
    var db = Firestore.firestore()
    var userNameArray = [String]()
    var doneLoadUserNameProtocol:DoneLoadUserNameProtocol?
    
    init(urlString:String) {
        
        self.urlString = urlString
        
    }
    
    
    init() {
        
    }
    
    //JSON解析
    func search() {
        
        let encodeUrlString = self.urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        AF.request(encodeUrlString as! URLConvertible, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            
            print(response)
            
            switch response.result {
            
            case .success:
                do {
                    let json:JSON = try JSON(data: response.data!)
                    print(json.debugDescription)
                    
                    let totalHitCount = json["pageInfo"]["resultPerpage"].int
                    
                    if totalHitCount! < 50 {
                        
                        self.resultPerpage = totalHitCount!
                        
                    }else {
                        
                        self.resultPerpage = totalHitCount!
                    }
                    
                    for i in 0...self.resultPerpage - 1 {
                        
                        if let title = json["items"][i]["snippet"]["title"].string, let description = json["items"][i]["snippet"]["description"].string, let url = json["items"][i]["snippet"]["thumbnails"]["default"]["url"].string, let channelTitle = json["items"][i]["snippet"]["channelTitle"].string, let publishTime = json["items"][i]["snippet"]["publishTime"].string, let channelId = json["itmes"][i]["snippet"]["channelId"].string {
                            
                            if json["items"][i]["id"]["channelId"].string == channelId {
                                
                                
                            }else {
                                
                                let dataSets = DataSets(videoID: json["items"][i]["id"]["videoId"].string, title: title, description: description, url: url, channelTitle: channelTitle, publishTime: publishTime)
                                
                                
                                if title.contains("Error 404") == true || description.contains("Error 404") == true || url.contains("Error 404") == true || channelTitle.contains("Error 404") == true || publishTime.contains("Error 404") == true {
                                    
                                    
                                }else {
                                    
                                    self.dataSetsArray.append(dataSets)
                                    
                                }
                                
                            }
                            
                        }else {
                            
                            print("空です。何か不足しています")
                        }
                    }
                    
                    self.doneCatchDataProtocol?.doneCatchData(array: self.dataSetsArray)
                    
                } catch {
                    
                    
                    
                }
                
            case .failure(_): break
                
            }
        }
    }
    
    //myListの受信
    func loadMyListData(userName:String) {
        
        db.collection("contents").document(userName).collection("collection").order(by: "postDate").addSnapshotListener { (snapShot, error) in
            
            self.dataSetsArray = []
            
            if error != nil {
                
                print(error.debugDescription)
                return
            }
            
            
            if let snapShotDoc = snapShot?.documents {
                
                for doc in snapShotDoc {
                    
                    let data = doc.data()
                    print(data.debugDescription)
                    if let videoID = data["videoID"] as? String, let urlString = data["urlString"] as? String, let publishTime = data["publishTime"] as? String, let title = data["title"] as? String, let description = data["description"] as? String, let channelTitle = data["channelTitle"] as? String {
                        
                        let dataSets = DataSets(videoID: videoID, title: title, description: description, url: urlString, channelTitle: channelTitle, publishTime: publishTime)
                        
                        self.dataSetsArray.append(dataSets)
                        
                    }
                    
                }
                
                self.doneLoadDataProtocol?.doneloadData(array: self.dataSetsArray)
                
            }
            
            
        }
        
    }
    
    //ユーザー名を取得する
    func loadOtherListData() {
        
        
        db.collection("Users").addSnapshotListener { (snapShot, error) in
            
            if let snapShotDoc = snapShot?.documents {
                
                for doc in snapShotDoc {
                    
                    let data = doc.data()
                    if let userName = data["userName"] as? String {
                        
                        self.userNameArray.append(userName)
                    }
                }
                
                //controller側にprotocolを用いて値を渡す
                self.doneLoadUserNameProtocol?.doneLoadUserName(array: self.userNameArray)
                
                
            }
        }
        
    }
    
    
    
}
