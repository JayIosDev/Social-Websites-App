

//
//  HomePageVC.swift
//  GoogleSignInDemo
//
//  Created by Jayaram G on 09/01/19.
//  Copyright © 2019 Jayaram G. All rights reserved.
//

import UIKit
import GoogleSignIn

class HomePageVC: UIViewController {
    
    
   
    
    var incomingGoogleUser:GIDGoogleUser!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    
    @IBOutlet weak var UserIdLbl: UILabel!
    
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBAction func logoutAct(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
       
        
        
        UserIdLbl.text = incomingGoogleUser.userID
        nameLbl.text = incomingGoogleUser.profile.givenName
        emailLbl.text = incomingGoogleUser.profile.email
        var userImage:UIImage!
        if incomingGoogleUser.profile.hasImage{
            
            let imageUrl = incomingGoogleUser.profile.imageURL(withDimension: 120)
            URLSession.shared.dataTask(with: imageUrl!) { (imgData, resp, err) in
                if err == nil {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage.init(data: imgData!)
                    }
                }
                }.resume()
        }
        
    }
    
    
    
}
