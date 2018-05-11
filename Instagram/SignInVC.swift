//
//  SignInVC.swift
//  Instagram
//
//  Created by rf-wen on 2018/2/7.
//  Copyright © 2018年 rf-wen. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {

    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let hideTap = UITapGestureRecognizer.init(target: self, action:#selector(hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func hideKeyboardTap(recognizer:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @IBAction func signInBtn_clicked(_ sender: UIButton) {
        print("登录按钮点击")
        
        self.view.endEditing(true)
        
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty{
            let alert = UIAlertController.init(title: "请注意", message: "请填好所有字段", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        AVUser.logInWithUsername(inBackground: usernameTxt.text!, password: passwordTxt.text!) { (user:AVUser?, error:Error?) in
            
            if error == nil{
                UserDefaults.standard.set(user!.username, forKey: "username")
                UserDefaults.standard.synchronize()
                
                let appDelegate :AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
            }
        }
    }
    @IBAction func signUpBtn_Clicked(_ sender: UIButton) {
        print("注册按钮点击")
    }
    @IBAction func forgotBtn_clicked(_ sender: UIButton) {
        print("忘记密码按钮点击")
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
