//
//  ListViewController.swift
//  YoutubeApp0
//
//  Created by Manabu Kuramochi on 2021/04/19.
//

import UIKit
import SDWebImage
import youtube_ios_player_helper

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DoneLoadDataProtocol, DoneLoadUserNameProtocol, YTPlayerViewDelegate {
   
    
    
    
    
    var tag = Int()
    var userName = String()
    var dataSetsArray = [DataSets]()
    var userNameArray = [String]()
    var searchAndLoad = SearchAndLoadModel()
    var youtubeView = YTPlayerView()
    
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(tag)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "VideoCell")
        tableView.register(UINib(nibName: "UserNameCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        
        searchAndLoad.doneLoadDataProtocol = self
        searchAndLoad.doneLoadUserNameProtocol = self
        
        if tag == 1 {
            
            //myList
            searchAndLoad.loadMyListData(userName: userName)
            
        }else if tag == 2{
            
            //ourList
            searchAndLoad.loadOtherListData()
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        
        if tag == 1 {
            self.navigationItem.title = "自分のリスト"
        }else if tag == 2 {
            self.navigationItem.title = "みんなのリスト"
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tag == 1 {
            
            return dataSetsArray.count
            
        }else if tag == 2 {
            
            return userNameArray.count
            
        }else {
            
            return 1
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tag == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
            cell.titleLabel.text = dataSetsArray[indexPath.row].title
            cell.thumnailImageView.sd_setImage(with: URL(string: dataSetsArray[indexPath.row].url!), completed: nil)
            cell.channelTitleLabel.text = dataSetsArray[indexPath.row].channelTitle
            cell.dateLabel.text = dataSetsArray[indexPath.row].publishTime
            
            return cell
            
        }else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserNameCell
            
            cell.userNameLabel.text = userNameArray[indexPath.row]
            return cell
            
        }
    }
    
    func doneloadData(array: [DataSets]) {
        
        dataSetsArray = array
        tableView.reloadData()
    }
    
    
    func doneLoadUserName(array: [String]) {
        
        userNameArray = []
        
        //重複を消す
        let orderedSet = NSOrderedSet(array: array)
        print(orderedSet.debugDescription)
        userNameArray = orderedSet.array as! [String]
        
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if tag == 1 {
            
            //myList(youtubeを再生)
            youtubeView.removeFromSuperview()
            
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            
            let navBarHeight = self.navigationController?.navigationBar.frame.size.height
            
            youtubeView = YTPlayerView(frame: CGRect(x: 0, y: statusBarHeight + navBarHeight!, width: view.frame.size.width, height: 240))
            
            youtubeView.delegate = self
            youtubeView.load(withVideoId: String(dataSetsArray[indexPath.row].videoID!), playerVars: ["playersinline":1])
            view.addSubview(youtubeView)
            
        }else {
            
            //DetailVCへ画面遷移
            
            
        }
        
        
        
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
