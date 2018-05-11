 //
//  HomeVC.swift
//  Instagram
//
//  Created by rf-wen on 2018/2/8.
//  Copyright © 2018年 rf-wen. All rights reserved.
//

import UIKit

//private let reuseIdentifier = "Cell"

class HomeVC: UICollectionViewController {
    
    
    var refresher:UIRefreshControl!
    var qureyCount = Bool()
    var page:Int = 12
    var puuidArray = [String]()
    var picArray = [AVFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.navigationItem.title = AVUser.current()?.username?.uppercased()
        self.collectionView?.alwaysBounceVertical = true
//        refresher = UIRefreshControl()
//        refresher.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
//        collectionView?.addSubview(refresher)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue:"reload"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(uploaded), name: NSNotification.Name(rawValue:"uploaded"), object: nil)
        
        loadPosts()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func uploaded(){
        loadPosts()
    }
    
    @objc func reload(){
        self.collectionView?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AVUser.current()?.follow("5a7c6a77ac502e00325b7e7b", andCallback: { (success:Bool, error:Error?) in
            if success{
                print("关注成功")
            }else{
                print("关注失败")
            }
        })
        qureyCount = true
        
        self.tabBarController?.tabBar.isHidden = false
        
    }
    @IBAction func settingBtn_clicked(_ sender: UIButton) {
        
        let UserSetting = self.storyboard?.instantiateViewController(withIdentifier: "UserSettingVC") as! UserSettingVC
        self.navigationController?.pushViewController(UserSetting, animated: true)
    }
    
    
    @objc func refresh(){
        collectionView?.reloadData()
        refresher.endRefreshing()
    }
    
    func loadPosts(){
        let query = AVQuery.init(className: "Posts")
        query.whereKey("username", equalTo: AVUser.current()?.username as Any)
        query.limit = page
        query.findObjectsInBackground { (objects:[Any]?, error:Error?) in
        
            if error == nil{
                self.puuidArray.removeAll(keepingCapacity:false)
                self.picArray.removeAll(keepingCapacity: false)
                for object in objects!{
                    self.puuidArray.append((object as AnyObject).value(forKey: "puuid") as! String)
                    self.picArray.append((object as AnyObject).value(forKey: "pic") as! AVFile)
                    print((object as AnyObject).value(forKey: "title") as! String)
                    
                }
                self.collectionView?.reloadData()
            }
            
            
        }
    }
    /**
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.height{
            loadMore()
        }
    }
    
    func loadMore(){
        if page <= picArray.count{
            page = page + 12
            
            let query = AVQuery.init(className: "Posts")
            query.whereKey("username", equalTo: AVUser.current()?.username as Any)
            query.limit = page
            query.findObjectsInBackground({ (objects:[Any]?, error:Error?) in
                if error == nil{
                    self.puuidArray.removeAll(keepingCapacity: true)
                    self.picArray.removeAll(keepingCapacity: true)
                    
                    for object in objects!{
                        self.puuidArray.append((object as AnyObject).value(forKey: "puuid") as! String)
                        self.picArray.append((object as AnyObject).value(forKey: "pic") as! AVFile)
                    }
                    print("loaded + \(self.page)")
                    self.collectionView?.reloadData()
                }else{
                    
                }
            })
        }
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return picArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = self.collectionView?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as!HeaderView
        
        header.fullnameLbe.text = (AVUser.current()?.object(forKey: "fullname") as? String)?.uppercased()
        header.webText.text = AVUser.current()?.object(forKey: "web") as? String
        header.webText.sizeToFit()
        header.bioLbl.text = AVUser.current()?.object(forKey: "bio") as? String
        header.bioLbl.sizeToFit()
        
        let avaQuery = AVUser.current()?.object(forKey: "ava") as! AVFile
        avaQuery.getDataInBackground { (data:Data?, error:Error?) in
            if data == nil{
                print(error?.localizedDescription as Any)
            }else{
                header.avaImg.image = UIImage.init(data: data!)
            }
            
        }
        
        let postsTap = UITapGestureRecognizer.init(target: self, action: #selector(postsTap(_:)))
        postsTap.numberOfTapsRequired = 1
        header.posts.isUserInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
        
        let followersTap = UITapGestureRecognizer.init(target: self, action: #selector(followersTap(_:)))
        followersTap.numberOfTapsRequired = 1
        header.followers.isUserInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        
        let followingsTap = UITapGestureRecognizer.init(target: self, action: #selector(followingsTap(_:)))
        followingsTap.numberOfTapsRequired = 1
        header.followings.isUserInteractionEnabled = true
        header.followings.addGestureRecognizer(followingsTap)
        
        if qureyCount == true{
            let currentUser:AVUser = AVUser.current()!
            let postsQuery = AVQuery.init(className: "Posts")
            postsQuery.whereKey("username", equalTo: currentUser.username as Any)
            postsQuery.countObjectsInBackground { (count:Int, error:Error?) in
                if error == nil{
                    header.posts.text = String(count)
                }
            }
            
            let followersQuery = AVQuery.init(className: "_Follower")
            followersQuery.whereKey("user", equalTo: currentUser)
            followersQuery.countObjectsInBackground { (count:Int, error:Error?) in
                if error == nil{
                    header.followers.text = String(count)
                }
            }
            
            let followeesQuery = AVQuery.init(className: "_Followee")
            followeesQuery.whereKey("user", equalTo: currentUser)
            followeesQuery.countObjectsInBackground { (count:Int, error:Error?) in
                if error == nil{
                    header.followings.text = String(count)
                }
            }
            
            qureyCount = false
        }
        
        
        
        return header
    }
    
    @objc func postsTap(_ recognizer : UITapGestureRecognizer){
        if !picArray.isEmpty{
            let index = IndexPath.init(item: 0, section: 0)
            self.collectionView?.scrollToItem(at: index, at: UICollectionViewScrollPosition.top, animated: true)
        }
    
    }
    
    @objc func followersTap(_ recognizer : UITapGestureRecognizer){
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC
        followers.user = (AVUser.current()?.username)!
        followers.show = "关 注 者"
        
        let storyboard1 : UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let myTabBar = storyboard1.instantiateViewController(withIdentifier: "TabBar")
        myTabBar.tabBarController?.tabBar.isHidden = true
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    @objc func followingsTap(_ recognizer : UITapGestureRecognizer){
        let followings = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC
        followings.user = (AVUser.current()?.username)!
        followings.show = "关 注"
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(followings, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        postPuuid.append(puuidArray[indexPath.row])
        print(postPuuid,indexPath.row)
        
        let postVc = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostVC
        self.navigationController?.pushViewController(postVc, animated: true)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PictureCell
    
        picArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
            if error == nil{
                cell.picImg.image = UIImage.init(data: data!)
            }else{
                print(error?.localizedDescription as Any)
            }
        }
        // Configure the cell
    
        return cell
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
