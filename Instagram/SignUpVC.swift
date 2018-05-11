//
//  SignUpVC.swift
//  Instagram
//
//  Created by rf-wen on 2018/2/7.
//  Copyright © 2018年 rf-wen. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repertpasswordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    var scrollViewHeiht: CGFloat = 0
    var keyboard:CGRect = CGRect()
    
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var cancelbtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.frame = CGRect(x:0,y:0,width:self.view.frame.width,height:self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeiht = self.view.frame.height
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        let hideTap = UITapGestureRecognizer.init(target: self, action:#selector(hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        avaImg.layer.cornerRadius = avaImg.frame.width / 2
        avaImg.clipsToBounds = true
        
        
        let imgTap = UITapGestureRecognizer.init(target: self, action:#selector(loadImg))
        imgTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(imgTap)
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpBtn_clicked(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || repertpasswordTxt.text!.isEmpty || emailTxt.text!.isEmpty || fullnameTxt.text!.isEmpty || bioTxt.text!.isEmpty || webTxt.text!.isEmpty{
            let alert = UIAlertController.init(title: "请注意", message: "请填好所有字段", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if passwordTxt.text != repertpasswordTxt.text{
            let alert = UIAlertController.init(title: "请注意", message: "两次输入的密码不一致", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let user = AVUser.init()
        user.username = usernameTxt.text?.lowercased()
        user.password = passwordTxt.text
        user.email = emailTxt.text?.lowercased()
        
        user["fullname"] = fullnameTxt.text?.lowercased()
        user["bio"] = bioTxt.text
        user["web"] = webTxt.text?.lowercased()
        
        if self.avaImg.image != nil{
            let avaData = UIImageJPEGRepresentation(self.avaImg.image!, 0.5)
            let imageName = String.init(format: "%@.jpg", user.username!)
            let avaFile = AVFile.init(name: imageName, data: avaData!)
            user["ava"] = avaFile
        }
        
        user.signUpInBackground { (success:Bool, error:Error?) in
            if success{

                print("用户注册成功")
                self.dismiss(animated: true, completion: nil)
                UserDefaults.standard.set(user.username, forKey: "username")
                UserDefaults.standard.synchronize()
            }else{
                print(error?.localizedDescription as Any)
            }
        }
        
    }
    
    @IBAction func cancelBtn_Clicked(_ sender: UIButton) {
        print("取消")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func showKeyboard(notification:NSNotification){
        let rect = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        keyboard = rect.cgRectValue
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.scrollViewHeiht - self.keyboard.size.height
        }
    }
    
    @objc func hideKeyboard(notification:NSNotification){
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.view.frame.height
        }
    }
    
    @objc func hideKeyboardTap(recognizer:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @objc func loadImg(recognizer:UITapGestureRecognizer){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
