
//
//  myViewController.swift
//  GoogleSignInDemo
//
//  Created by Jayaram G on 10/01/19.
//  Copyright © 2019 Jayaram G. All rights reserved.

import UIKit

class myViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logout(_ sender: UIButton) {
        let loginVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? ViewController
        self.present(loginVc!,animated: true,completion: nil)
        
    }
    
}
