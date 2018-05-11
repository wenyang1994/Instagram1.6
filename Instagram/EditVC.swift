//
//  EditVc.swift
//  Instagram
//
//  Created by rf-wen on 2018/2/9.
//  Copyright © 2018年 rf-wen. All rights reserved.
//

import UIKit

class EditVC: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
    @IBOutlet weak var bioText: UITextView!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var telTxt: UITextField!
    @IBOutlet weak var genderTxt: UITextField!
    
    
    var genderPicker : UIPickerView!
    let genders = ["男","女"]
    
    var keyboard = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alignment()
        information()
        
        genderPicker = UIPickerView()
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.backgroundColor = UIColor.groupTableViewBackground
        genderPicker.showsSelectionIndicator = true
        genderTxt.inputView = genderPicker
        
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
    
    func alignment(){
        
    }
    
    func information(){
        let ava = AVUser.current()?.object(forKey: "ava") as! AVFile
        ava.getDataInBackground { (data:Data?, error:Error?) in
            if error == nil{
                self.avaImg.image = UIImage.init(data: data!)
            }
        }
        
        usernameTxt.text = AVUser.current()?.username
        fullnameTxt.text = AVUser.current()?.object(forKey: "fullname") as? String
        bioText.text = AVUser.current()?.object(forKey: "bio") as? String
        webTxt.text = AVUser.current()?.object(forKey: "web") as? String
        
        emailTxt.text = AVUser.current()?.email
        telTxt.text = AVUser.current()?.mobilePhoneNumber
        genderTxt.text = AVUser.current()?.object(forKey: "gender") as? String
        
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
    
    @objc func showKeyboard(notification:NSNotification){
        let rect = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        keyboard = rect.cgRectValue
        UIView.animate(withDuration: 0.4) {
            self.scrollView.contentSize.height = self.view.frame.height + self.keyboard.height / 2
        }
    }
    
    @objc func hideKeyboard(notification:NSNotification){
        UIView.animate(withDuration: 0.4) {
            self.scrollView.contentSize.height = 0
        }
    }
    
    @objc func hideKeyboardTap(recognizer:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @IBAction func save_clicked(_ sender: Any) {
        
        if usernameTxt.text!.isEmpty || emailTxt.text!.isEmpty || fullnameTxt.text!.isEmpty || bioText.text!.isEmpty || webTxt.text!.isEmpty{
            let alert = UIAlertController.init(title: "请注意", message: "请填好所有字段", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let user = AVUser.current()
        user?.username = usernameTxt.text?.lowercased()
        user?.mobilePhoneNumber = telTxt.text
        user?.email = emailTxt.text?.lowercased()
        
        user?["fullname"] = fullnameTxt.text?.lowercased()
        user?["bio"] = bioText.text
        user?["web"] = webTxt.text?.lowercased()
        user?["gender"] = genderTxt.text
        
        if self.avaImg.image != nil{
            let avaData = UIImageJPEGRepresentation(self.avaImg.image!, 0.5)
            let imageName = String.init(format: "%@.jpg", (user?.username)!)
            let avaFile = AVFile.init(name: imageName, data: avaData!)
            user?["ava"] = avaFile
            
        }
        
        user?.saveInBackground { (success:Bool, error:Error?) in
            if success{
                
                print("修改成功")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:"reload"), object: nil)
                self.view.endEditing(true)
                self.dismiss(animated: true, completion: nil)
                
            }else{
                print(error?.localizedDescription as Any)
            }
        }
        
    }
    
    
    @IBAction func cancle_clicked(_ sender: Any) {
        
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTxt.text = genders[row]
        self.view.endEditing(true)
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
