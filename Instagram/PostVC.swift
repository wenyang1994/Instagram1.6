//
//  PostVC.swift
//  Instagram
//
//  Created by rf-wen on 2018/2/11.
//  Copyright © 2018年 rf-wen. All rights reserved.
//

import UIKit

var postPuuid = [String]()

class PostVC: UITableViewController {

    var avaArray = [AVFile]()
    var usernameArray = [String]()
    var dateArray = [Date]()
    var picArray = [AVFile]()
    var puuidArray = [String]()
    var titleArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let backSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(back(_:)))
        backSwipe.direction = .right
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(backSwipe)
        
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(back(_:)))
        self.navigationItem.leftBarButtonItem = backBtn
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Notification.Name.init("liked"), object: nil)
        
    }
    @objc func refresh(){
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let postQuery = AVQuery.init(className: "Posts")
        print(postPuuid)
        
        postQuery.whereKey("puuid", equalTo: postPuuid.last as Any)
        
        postQuery.findObjectsInBackground { (objects:[Any]?,error:Error? ) in
            self.avaArray.removeAll(keepingCapacity: false)
            self.usernameArray.removeAll(keepingCapacity: false)
            self.dateArray.removeAll(keepingCapacity: false)
            self.picArray.removeAll(keepingCapacity: false)
            self.puuidArray.removeAll(keepingCapacity: false)
            self.titleArray.removeAll(keepingCapacity: false)
            
            for object in objects!{
                self.avaArray.append((object as AnyObject).value(forKey: "ava") as! AVFile)
                self.usernameArray.append((object as AnyObject).value(forKey: "username") as! String)
                self.dateArray.append(((object as AnyObject).createdAt as? Date)!)
                self.picArray.append((object as AnyObject).value(forKey: "pic") as! AVFile)
                self.puuidArray.append((object as AnyObject).value(forKey: "puuid") as! String)
                self.titleArray.append((object as AnyObject).value(forKey: "title") as! String)
            }
            self.tableView.reloadData()
        }
    }
    
    @objc func back(_ sender:UIBarButtonItem){
        
        self.navigationController?.popViewController(animated: true)
        
        if !postPuuid.isEmpty{
            postPuuid.removeLast()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernameArray.count
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        print(usernameArray.count,indexPath.row)
        
        cell.usernameBtn.setTitle(usernameArray[indexPath.row], for: .normal)
        cell.puuidLbl.text = puuidArray[indexPath.row]
        cell.titleLbl.text = titleArray[indexPath.row]
        
        avaArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
            cell.avaImg.image = UIImage.init(data: data!)
        }
        picArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
            cell.picImg.image = UIImage.init(data: data!)
        }
        
        let from = dateArray[indexPath.row]
        
        let now = Date()
        let components:Set<Calendar.Component> = [.second,.minute,.hour,.day,.weekOfMonth]
        let difference = Calendar.current.dateComponents(components, from: from,to: now)
        
        if difference.second! <= 0{
            cell.dateLbl.text = "现在"
        }
        
        if difference.second! > 0 && difference.minute! <= 0{
            cell.dateLbl.text = "\(difference.second!)秒"
        }

        if difference.minute! > 0 && difference.hour! <= 0 {
            cell.dateLbl.text = "\(difference.minute!)分"
        }
        
        if difference.hour! > 0 && difference.day! <= 0{
            cell.dateLbl.text = "\(difference.hour!)时"
        }
        if difference.day! > 0 && difference.weekOfMonth! <= 0{
            cell.dateLbl.text = "\(difference.day!)天"
        }
        
        if difference.weekOfMonth! > 0 {
            cell.dateLbl.text = "\(difference.weekOfMonth!)周"
        }
        
        cell.titleLbl.text = titleArray[indexPath.row]
        cell.titleLbl.sizeToFit()
        cell.usernameBtn.sizeToFit()
        
        let didLike = AVQuery.init(className: "Likes")
        didLike.whereKey("by", equalTo: AVUser.current()?.username as Any)
        didLike.whereKey("to", equalTo: cell.puuidLbl.text!)
        
        didLike.countObjectsInBackground { (count:Int, error:Error?) in
            if count == 0{
                cell.likeBtn.setTitle("unlike", for: .normal)
            }else{
                cell.likeBtn.setTitle("like", for: .normal)
            }
        }
        
        let countLikes = AVQuery.init(className: "Likes")
        countLikes.whereKey("to", equalTo: cell.puuidLbl.text!)
        countLikes.countObjectsInBackground { (count:Int, error:Error?) in
            cell.likeLbl.text = "\(count)"
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
