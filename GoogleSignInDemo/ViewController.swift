//
//  ViewController.swift
//  GoogleSignInDemo
//
//  Created by Jayaram G on 07/01/19.
//  Copyright © 2019 Jayaram G. All rights reserved.
//

import UIKit
import GoogleSignIn
import AccountKit
import CountryPickerView
import Alamofire
import GoogleMaps
import GooglePlaces
class ViewController: UIViewController,GIDSignInUIDelegate,AKFViewControllerDelegate,UITextFieldDelegate {
  
    
    @IBOutlet weak var countryPickerView: CountryPickerView!
    @IBOutlet weak var SigninGoogle: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.uiDelegate = self
        fetchingJsonDataFromServer()
        getLoginDetails()
        setUpGoogleButton()
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func prepareFBLoginViewController(loginViewController:UIViewController & AKFViewController){
        loginViewController.delegate = self
        loginViewController.enableSendToFacebook = true
        loginViewController.enableGetACall = true
        
        // uiTheme Modification
        loginViewController.uiManager = AKFSkinManager.init(skinType: .contemporary, primaryColor: .red)
        
        
    }
    
    func setUpGoogleButton(){
        
       SigninGoogle.style = .wide
        SigninGoogle.colorScheme = .dark
        
    }
    
    var accountKit:AKFAccountKit!

    @IBAction func FbLoginWithOtp(_ sender: UIButton) {
      //  accountKit = AKFAccountKit.init(responseType: .accessToken)
        // accountKit.viewControllerForPhoneLogin()
        accountKit = AKFAccountKit.init(responseType: .accessToken)
        // accountKit.viewControllerForPhoneLogin()
        let loginVC =  accountKit.viewControllerForPhoneLogin(with: nil, state: UUID.init().uuidString)
        self.prepareFBLoginViewController(loginViewController: loginVC)
        self.present(loginVC, animated: true, completion: nil)
    }
    
    @IBAction func FbLoginWithMail(_ sender: UIButton) {
        accountKit = AKFAccountKit.init(responseType: .accessToken)
        let loginEmailVC = accountKit.viewControllerForEmailLogin()
        self.prepareFBLoginViewController(loginViewController: loginEmailVC)
        self.present(loginEmailVC, animated: true, completion: nil)

    }
    
    
    
    
   
    
    
    
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        
        let homeVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FbHomeVC") as! FbHomeViewController
        
        
        // Capture the Account info
        
        accountKit.requestAccount { (account, error) in
            
            if error == nil {
                
                let accountId = account?.accountID
                
                var email:String?
                if let currentEmail = account?.emailAddress{
                    email = currentEmail
                    
                }
                var phoneNum:String?
                
                if let phone = account?.phoneNumber {
                    
                    phoneNum = phone.phoneNumber
                }
                
                homeVc.accountIdStr = accountId
                homeVc.emailStr = email
                homeVc.phoneStr = phoneNum
                homeVc.incomingAccountKit = self.accountKit
                self.present(homeVc, animated: true, completion: nil)
            }
            
        }
        
        
        
        
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        
        print(error.localizedDescription)
        
    }
    
    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
        
        print("User cancelled operation")
    }

   
    @IBOutlet weak var countryCodeTextfield: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    
    @IBAction func verification(_ sender: UIButton) {
        verifyingOTPCode()
    }
    
    
    @IBAction func sendOtp(_ sender: UIButton) {
        sendingOTP()

    }
    
    
    func sendingOTP() {
        let countryCode = countryPickerView.selectedCountry.phoneCode
        let phoneNumber = phoneNumberTextField.text
        
        print(countryCode)
       
        let params: [String: Any] = ["country_code": countryCode as Any, "phone_number": phoneNumber as Any]
        var request  = URLRequest(url: URL(string: "https://api.authy.com/protected/json/phones/verification/start?api_key=8guB29Gck2rQTh9D0fGJrgl5UxP5gccP&via=sms")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("token", forHTTPHeaderField: "Authorization")
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }catch let error{
            print("params boday error \(error)")
        };
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let jsonData = data, let lResponse  = response as? HTTPURLResponse{
                
                do {
                    print("status code \(lResponse.statusCode)")
                    
                    let userData = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)as! [String:Any]
                    
                    print(userData)
                    
                    
                }catch let decodeError {
                    print("decodeError \(decodeError)")
                }
                return
            }
            
            if let lError = error {
                print(lError.localizedDescription)
                print("API error \(String(describing: error))")
                return
            }
        }
        task.resume()
    }
    
    
    
    
    
    
    
    
    @IBOutlet weak var OtpTextField: UITextField!
    
    var userArray = [String:Any]()

    func verifyingOTPCode(){
        
        let otpCode = OtpTextField.text
        let mobileNumber = phoneNumberTextField.text
        let countryCode = countryPickerView.selectedCountry.phoneCode
        
        let apiKey1 = "8guB29Gck2rQTh9D0fGJrgl5UxP5gccP"
        
        
        let urlStr = String(format: "https://api.authy.com/protected/json/phones/verification/check?api_key=%@&verification_code=%@&phone_number=%@&country_code=%@",apiKey1,otpCode!,mobileNumber!,countryCode)
        print(urlStr)
        var request =  URLRequest(url: URL(string: urlStr)!)
        request.httpMethod="GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler:
        {
            (data:Data?,response:URLResponse?,error:Error?)->Void
            in
            if(error==nil)
            {
                DispatchQueue.main.async {
                    do
                    {
                        try self.userArray = JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String:Any]
                        
                        print(self.userArray)
                        
                    let message = self.userArray["message"] as! String
                        if message == "Verification code is correct."{
                            print("Login successfully")
                            
                            let myVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "myVC") as! myViewController
                            self.present(myVC,animated: true,completion: nil)
                            
                            
                            
                        }else {
                            print("invalid OTP please try again")
                            let alert = UIAlertController.init(title: "Warning", message: "You entered Wrong OTP", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Go back", style: .default, handler: nil))
                            self.present(alert,animated: true,completion: nil)
                        }
                        
                    }
                    catch
                    {
                        print("error \(error)")
                    }
                }
            }
        })
        task.resume();
    }
    
    
    
    func fetchingJsonDataFromServer(){
        
        let page:Int = 1

        
        let apikey:String = "1"
        let show  = "inbox"
        let departments = "All"
        let Token1: String? = UserDefaults.standard.string(forKey: "TokenKey") ?? ""
        let urlStr = String(format: "http://faveo-mobileapps.tk/helpdeskMobile/public/api/v2/helpdesk/get-tickets?api=%@&show=%@&departments=%@&page=%d",apikey,show,departments,page)
        var request =  URLRequest(url: URL(string: urlStr)!)
        
        //let apiToken = Token1
       // let headers = ["token":Token1]
      //  request.allHTTPHeaderFields = headers as? [String : String]
        request.setValue(Token1, forHTTPHeaderField: "token")
        request.httpMethod="GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler:
        {
            (data:Data?,response:URLResponse?,error:Error?)->Void
            in
            if error == nil
            {
                DispatchQueue.main.async {
                    do
                    {
                        try self.userArray = JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String:Any]
                           print(self.userArray)
                        
                        let data = self.userArray["data"] as? [String:Any]
                        let secData = data?["data"] as? [[String:Any]]
                        //    let fromDict = secData?[indexPath.row]["from"] as? [String:AnyObject]
                        
                        //print(secData)
                        
                        
                        
                        
                        if self.userArray["message"] != nil  {
                            let messageCode:String = self.userArray["message"] as! String
                            if  messageCode == "Token expired"  {
                                print("expired 123")
                                freshToken()
                                self.fetchingJsonDataFromServer()
                            }
                        }
                        else{
                            print(" getting data ")
                            print(self.userArray)
                            
                        }
                    }
                    catch
                    {
                        print("error \(error.localizedDescription)")
                    }
                }
            }
        })
        task.resume();
    }
    
    
    
    func getLoginDetails() {
        
        let userName = "demoadmin"
        let passWord = "demopass"
        let params: [String: Any] = ["username": userName as Any, "password": passWord as Any]
        var request  = URLRequest(url: URL(string: "http://faveo-mobileapps.tk/helpdeskMobile/public/api/v1/authenticate")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("token", forHTTPHeaderField: "Authorization")
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }catch let error{
            print("params boday error \(error)")
        };
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let jsonData = data, let lResponse  = response as? HTTPURLResponse{
                
                do {
                    print("status code \(lResponse.statusCode)")
                    
                    
                    var userData = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)as! [String:Any]
                    
                    print(userData)
                    
                    let data:[String:Any]! = userData["data"] as? [String : Any]
                    if userData["success"] != nil && userData["data"] != nil{
                        let successValue:Int = userData["success"] as! Int
                        print(successValue)
                        
                        if successValue == 1  {
                            let tokenValue = data["token"]!
                            UserDefaults.standard.set(tokenValue, forKey: "TokenKey")
                      
                        }else{
                            //error
                        }
                    }
                    
                    
                }catch let decodeError {
                    print("decodeError \(decodeError)")
                }
                return
            }
            
            if let lError = error {
                print(lError.localizedDescription)
                print("API error \(String(describing: error))")
                return
            }
        }
        task.resume()
    }
    
    
    

    
    
}
