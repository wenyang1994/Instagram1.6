//
//  HeaderView.swift
//  Instagram
//
//  Created by rf-wen on 2018/2/8.
//  Copyright © 2018年 rf-wen. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var fullnameLbe: UILabel!
    @IBOutlet weak var webText: UITextView!
    @IBOutlet weak var bioLbl: UILabel!
    
    
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var followings: UILabel!
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var followersTitle: UILabel!
    @IBOutlet weak var followingTitle: UILabel!
    @IBOutlet weak var editBtn: UIButton!
        
    @IBOutlet weak var settingBtn: UIButton!
}
