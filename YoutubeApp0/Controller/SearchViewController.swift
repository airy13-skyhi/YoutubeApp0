//
//  SearchViewController.swift
//  YoutubeApp0
//
//  Created by Manabu Kuramochi on 2021/04/17.
//

import UIKit
import youtube_ios_player_helper
import FirebaseAuth
import FirebaseFirestore


class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DonecatchDataProtocol, YTPlayerViewDelegate {
    
    
    
    
    //AIzaSyAIfrCBLdmA2JFKZiC4t6hQSbnREvtsNlY
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var dataSetsArray = [DataSets]()
    var userName = String()
    var db = Firestore.firestore()
    var userID = String()
    var youtubeView = YTPlayerView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "VideoCell")
        
        if UserDefaults.standard.object(forKey: "userName") != nil {
            
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSetsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
        
        cell.thumnailImageView.sd_setImage(with: URL(string: dataSetsArray[indexPath.row].url!), completed: nil)
        
        cell.titleLabel.text = dataSetsArray[indexPath.row].title
        cell.channelTitleLabel.text = dataSetsArray[indexPath.row].channelTitle
        cell.dateLabel.text = dataSetsArray[indexPath.row].publishTime
        
        
        //fav?????????
        let favButton = UIButton(frame: CGRect(x: 330, y: 32, width: 40, height: 46))
        favButton.setImage(UIImage(named: "fav"), for: .normal)
        favButton.addTarget(self, action: #selector(favButtonTap(_:)), for: .touchUpInside)
        favButton.tag = indexPath.row
        cell.contentView.addSubview(favButton)
        
        return cell
    }
    
    @objc func favButtonTap(_ sender:UIButton) {
        
        //DB????????????????????????
        print(sender.tag)
        let sendDB = SendDB(userID: Auth.auth().currentUser!.uid, userName: userName, urlString: dataSetsArray[sender.tag].url!, videoID: dataSetsArray[sender.tag].videoID!, title: dataSetsArray[sender.tag].title!, publishTime: dataSetsArray[sender.tag].publishTime!, description: dataSetsArray[sender.tag].description!, channelTitle: dataSetsArray[sender.tag].channelTitle!)
        
        sendDB.sendData(userName: userName)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        youtubeView.removeFromSuperview()
        
        //statusBar??????????????????
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        //navigationBar??????????????????
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        
        
        youtubeView = YTPlayerView(frame: CGRect(x: 0, y: statusBarHeight + navBarHeight!, width: view.frame.size.width, height: 240))
        youtubeView.load(withVideoId: String(dataSetsArray[indexPath.row].videoID!), playerVars: ["playersinline": 1])
        view.addSubview(youtubeView)
        
    }
    
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        
        playerView.playVideo()
    }
    
    
    
    
    @IBAction func search(_ sender: Any) {
        
        //textField?????????????????????????????????????????????Youtube??????????????????
        let urlString = "https://www.googleapis.com/youtube/v3/search?key=AIzaSyAIfrCBLdmA2JFKZiC4t6hQSbnREvtsNlY&part=snippet&q=\(searchTextField.text!)&maxResults=50"
        
        let searchModel = SearchAndLoadModel(urlString: urlString)
        searchModel.doneCatchDataProtocol = self
        searchModel.search()
        
    }
    
    
    func doneCatchData(array: [DataSets]) {
        
        print(array.debugDescription)
        dataSetsArray = array
        tableView.reloadData()
    }
    
    
    
    @IBAction func confirmList(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let listVC = storyboard?.instantiateViewController(withIdentifier: "listVC") as! ListViewController
        
        if (sender as AnyObject).tag == 1 {
          
            //myList
            listVC.tag = 1
            listVC.userName = userName
            
        }else {
            
            //ourList
            listVC.tag = 2
            
            
        }
        self.navigationController?.pushViewController(listVC, animated: true)
        
        
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
