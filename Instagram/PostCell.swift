//
//  PostCell.swift
//  Instagram
//
//  Created by rf-wen on 2018/2/11.
//  Copyright © 2018年 rf-wen. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var picImg: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var puuidLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let likeTap = UITapGestureRecognizer.init(target: self, action: #selector(likeTaped))
        likeTap.numberOfTapsRequired = 2
        picImg.isUserInteractionEnabled = true
        picImg.addGestureRecognizer(likeTap)
        
        // Initialization code
    }
    
    @objc func likeTaped(){
        let title = likeBtn.title(for: .normal)
        
        
        if title == "unlike"{
            let object = AVObject.init(className: "Likes")
            object["by"] = AVUser.current()?.username
            object["to"] = puuidLbl.text
            object.saveInBackground({ (success:Bool, error:Error?) in
                if success{
                    self.likeBtn.setTitle("like", for: .normal)
                    NotificationCenter.default.post(name: Notification.Name.init("liked"), object: nil)
                }
            })
        }else{
            let query = AVQuery.init(className: "Likes")
            query.whereKey("by", equalTo: AVUser.current()?.username! as Any)
            query.whereKey("to", equalTo: self.puuidLbl.text!)
            
            query.findObjectsInBackground({ (objects:[Any]?, error:Error?) in
                for object in objects!{
                    (object as AnyObject).deleteInBackground({ (success:Bool, error:Error?) in
                        if success{
                            self.likeBtn.setTitle("unlike", for: .normal)
                            NotificationCenter.default.post(name: Notification.Name.init("liked"), object: nil)
                        }
                    })
                }
            })
        }
    }
    
    @IBAction func likeBtn_clicked(_ sender: UIButton) {
        let title = sender.title(for: .normal)
        if title == "unlike"{
            let object = AVObject.init(className: "Likes")
            object["by"] = AVUser.current()?.username
            object["to"] = puuidLbl.text
            object.saveInBackground({ (success:Bool, error:Error?) in
                if success{
                    self.likeBtn.setTitle("like", for: .normal)
                    NotificationCenter.default.post(name: Notification.Name.init("liked"), object: nil)
                }else{
                    
                    
                }
            })
        }else{
            let query = AVQuery.init(className: "Likes")
            query.whereKey("by", equalTo: AVUser.current()?.username! as Any)
            query.whereKey("to", equalTo: self.puuidLbl.text!)
            
            query.findObjectsInBackground({ (objects:[Any]?, error:Error?) in
                for object in objects!{
                    (object as AnyObject).deleteInBackground({ (success:Bool, error:Error?) in
                        if success{
                            self.likeBtn.setTitle("unlike", for: .normal)
                            NotificationCenter.default.post(name: Notification.Name.init("liked"), object: nil)
                        }
                    })
                }
            })
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
