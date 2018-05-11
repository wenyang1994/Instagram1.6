//
//  FollowersCell.swift
//  Instagram
//
//  Created by rf-wen on 2018/2/8.
//  Copyright © 2018年 rf-wen. All rights reserved.
//

import UIKit

class FollowersCell: UITableViewCell {

    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    var user:AVUser!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avaImg.layer.cornerRadius = avaImg.frame.width / 2
        avaImg.clipsToBounds = true
        // Initialization code
    }
    
    @IBAction func follewBtn_clicked(_ sender: UIButton) {
        let title = followBtn.title(for:.normal)
        
        if title == "关 注"{
            guard user != nil else{ return }
            AVUser.current()?.follow(user.objectId!, andCallback: { (success:Bool, error:Error?) in
                if success{
                    self.followBtn.setTitle("已关注", for: .normal)
                    self.followBtn.backgroundColor = .green
                }else{
                    print(error?.localizedDescription as Any)
                }
            })
        }else{
            guard self.user != nil else{ return }
            AVUser.current()?.unfollow(self.user.objectId!, andCallback: { (success:Bool, error:Error?) in
                if success{
                    self.followBtn.setTitle("关 注", for: .normal)
                    self.followBtn.backgroundColor = .lightGray
                }else{
                    
                    print(error?.localizedDescription as Any)
                }
            })
        }
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
