//
//  UploadVC.swift
//  Instagram
//
//  Created by rf-wen on 2018/2/9.
//  Copyright © 2018年 rf-wen. All rights reserved.
//

import UIKit

class UploadVC: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    
    @IBOutlet weak var picImg: UIImageView!
    @IBOutlet weak var titleText: UITextView!
    @IBOutlet weak var publishBtn: UIButton!
    
    @IBOutlet weak var removeBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        publishBtn.isEnabled = false
        publishBtn.backgroundColor = .lightGray
        
        removeBtn.isHidden = true
        let picTap = UITapGestureRecognizer.init(target: self, action: #selector(selectImg))
        picTap.numberOfTapsRequired = 1
        self.picImg.isUserInteractionEnabled = true
        self.picImg.addGestureRecognizer(picTap)
        alignment()
        
        let hideTap = UITapGestureRecognizer.init(target: self, action:#selector(hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        picImg.image = nil
        titleText.text = nil
        
        // Do any additional setup after loading the view.
    }
    
    @objc func selectImg(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @objc func hideKeyboardTap(recognizer:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @IBAction func publishBtn_clicked(_ sender: UIButton) {
        self.view.endEditing(true)
        let object = AVObject.init(className: "Posts")
        object["username"] = AVUser.current()?.username
        object["ava"] = AVUser.current()?.value(forKey: "ava") as! AVFile
        object["puuid"] = "\(String(describing: AVUser.current()?.username!)) \(NSUUID().uuidString)"
     
        if titleText.text.isEmpty{
            object["title"] = ""
        }else{
            object["title"] = titleText.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        let imageData = UIImageJPEGRepresentation(picImg.image!, 0.5)
        let imageFile = AVFile.init(name: "post.jpg", data: imageData!)
        object["pic"] = imageFile
        
        object.saveInBackground { (success:Bool, error:Error?) in
            if error == nil{
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "uploaded"), object: nil)
                self.tabBarController?.selectedIndex = 0
                self.viewDidLoad()
            }else{
                
            }
        }
        
    }
    
    @IBAction func removeBtn_clicked(_ sender: UIButton) {
        self.viewDidLoad()
        self.view.endEditing(true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        removeBtn.isHidden = false
        publishBtn.isEnabled = true
        publishBtn.backgroundColor = UIColor.blue
        
        let zoomTap = UITapGestureRecognizer.init(target: self, action: #selector(zoomImg))
        zoomTap.numberOfTapsRequired = 1
        self.picImg.isUserInteractionEnabled = true
        self.picImg.addGestureRecognizer(zoomTap)
    }
    
    @objc func zoomImg(){
        let zoomed = CGRect(x: 0, y: self.view.center.y - self.view.center.x, width: self.view.frame.width, height: self.view.frame.width)
        
        let unzoomed = CGRect(x: 15, y: self.navigationController!.navigationBar.frame.height + 35, width: 90, height: 90)
        
        if picImg.frame == unzoomed{
            UIView.animate(withDuration: 0.3, animations: {
                self.picImg.frame = zoomed
                self.view.backgroundColor = .black
                self.titleText.alpha = 0
                self.publishBtn.alpha = 0
                self.removeBtn.alpha = 0
            })
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.picImg.frame = unzoomed
                self.view.backgroundColor = UIColor.groupTableViewBackground
                self.titleText.alpha = 1
                self.publishBtn.alpha = 1
                self.removeBtn.alpha = 1
            })
        }
    }
    
    func alignment(){
        
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
