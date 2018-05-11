//
//  GuestVC.swift
//  Instagram
//
//  Created by rf-wen on 2018/2/12.
//  Copyright © 2018年 rf-wen. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

var guestArray = [AVUser]()
class GuestVC: UICollectionViewController {

    var puuidArray = [String]()
    var picArray = [AVFile]()
    
    let page:Int = 12
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.alwaysBounceVertical = true
        self.navigationItem.title = guestArray.last?.username
        
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(back(_:)))
        self.navigationItem.leftBarButtonItem = backBtn
        
        let backSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(back(_:)))
        backSwipe.direction = .right
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(backSwipe)
        
       
        loadPosts()
       
    }
    
    func loadPosts(){
        let query = AVQuery.init(className: "Posts")
        query.whereKey("username", equalTo: guestArray.last?.username as Any)
        query.limit = page
        query.findObjectsInBackground { (objects:[Any]?, error:Error?) in
            
            if error == nil{
                self.puuidArray.removeAll(keepingCapacity:false)
                self.picArray.removeAll(keepingCapacity: false)
                for object in objects!{
                    self.puuidArray.append((object as AnyObject).value(forKey: "puuid") as! String)
                    self.picArray.append((object as AnyObject).value(forKey: "pic") as! AVFile)
                    
                }
                self.collectionView?.reloadData()
            }
            
            
        }
    }
    
    @objc func back(_ sender:UIBarButtonItem){
        
        self.navigationController?.popViewController(animated: true)
        
        if !guestArray.isEmpty{
            guestArray.removeLast()
        }
    }

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
        
        let infoQuery = AVQuery.init(className: "_User")
        infoQuery.whereKey("username", equalTo: guestArray.last?.username as Any)
        
        infoQuery.findObjectsInBackground { (objects:[Any]?, error:Error?) in
            if error == nil{
                guard let objects = objects,objects.count > 0 else { return }
            
                for object in objects{
                    header.fullnameLbe.text = ((object as AnyObject).object(forKey: "fullname") as? String)?.uppercased()
                    header.webText.text = (object as AnyObject).object(forKey: "web") as? String
                    header.webText.sizeToFit()
                    header.bioLbl.text = (object as AnyObject).object(forKey: "bio") as? String
                    header.bioLbl.sizeToFit()
                    
                    let avaFile = (object as AnyObject).object(forKey: "ava") as? AVFile
                    avaFile?.getDataInBackground({ (data:Data?, error:Error?) in
                        header.avaImg.image = UIImage.init(data: data!)
                    })
                }
            }else{
                
            }
        }
        
        let posts = AVQuery.init(className: "Posts")
        posts.whereKey("username", equalTo: guestArray.last?.username as Any)
        posts.countObjectsInBackground { (count:Int, error:Error?) in
            if error == nil{
                header.posts.text = "\(count)"
            }else{
                
            }
        }
        
        let followers = AVUser.followerQuery((guestArray.last?.objectId)!)
        
        followers.countObjectsInBackground { (count:Int, error:Error?) in
            if error == nil{
                header.followers.text = "\(count)"
            }else{
                
            }
        }
        
        let followings = AVUser.followeeQuery((guestArray.last?.objectId)!)
        
        followings.countObjectsInBackground { (count:Int, error:Error?) in
            if error == nil{
                header.followings.text = "\(count)"
            }else{
                
            }
        }
        
        let followeeQuery = AVUser.current()?.followeeQuery()
        followeeQuery?.whereKey("user", equalTo: AVUser.current() as Any)
        followeeQuery?.whereKey("followee", equalTo: guestArray.last as Any)
        followeeQuery?.countObjectsInBackground({ (count:Int, error:Error?) in
            guard error == nil else{ return }
            if count == 0{
                header.editBtn.setTitle("关 注", for: .normal)
                header.editBtn.backgroundColor = .lightGray
            }else{
                header.editBtn.setTitle("已关注", for: .normal)
                header.editBtn.backgroundColor = .green
            }
        })
        
        return header
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PictureCell
        picArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
            if error == nil{
                cell.picImg.image = UIImage.init(data: data!)
            }else{
                
            }
        }
    
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
