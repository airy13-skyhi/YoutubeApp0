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

class SearchAndLoadModel {
    
    var urlString = String()
    var resultPerpage = Int()
    
    
    init(urlString:String) {
        
        self.urlString = urlString
        
    }
    
    
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
                        
                        if let title = json["items"][i]["snippet"]["title"].string, let description = json["item"][i]["snippet"]["description"].string, let url = json["item"][i]["snippet"]["thumbnails"]["default"]["url"].string, let channelTitle = json["item"][i]["snippet"]["channelTitle"].string, let publishTime = json["items"][i]["snippet"]["publishTime"].string,  {
                            
                        }
                        
                    }
                    
                    
                    
                } catch {
                    
                    
                    
                }
                
            case .failure(_): break
                
            }
            
        }
    }
    
    
    
    
}
