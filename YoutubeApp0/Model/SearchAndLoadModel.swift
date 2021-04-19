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


class SearchAndLoadModel {
    
    var urlString = String()
    var resultPerpage = Int()
    var dataSetsArray:[DataSets] = []
    var doneCatchDataProtocol:DonecatchDataProtocol?
    
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
    
    
    
    
}
