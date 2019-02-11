//
//  FbHomeViewController.swift
//  GoogleSignInDemo
//
//  Created by Jayaram G on 09/01/19.
//  Copyright © 2019 Jayaram G. All rights reserved.
//

import UIKit
import AccountKit
class FbHomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    var accountIdStr:String?
    var emailStr:String?
    var phoneStr:String?
    var incomingAccountKit:AKFAccountKit!
    @IBOutlet weak var accountID: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        accountID.text = accountIdStr
        email.text = emailStr
        phone.text = phoneStr
    }
    @IBAction func logOutAtn(_ sender: UIButton) {
        incomingAccountKit.logOut()
        self.dismiss(animated: true, completion: nil)
        
    }
}
