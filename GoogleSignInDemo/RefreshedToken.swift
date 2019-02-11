//
//  RefreshedToken.swift
//  LoginApp
//
//  Created by Jayaram G on 15/12/18.
//  Copyright © 2018 Jayaram G. All rights reserved.
//

import Foundation

public func freshToken() {
      let userValue: String? = UserDefaults.standard.string(forKey: "NewUserNameKey") ?? ""
      let passWordValue: String? = UserDefaults.standard.string(forKey: "NewPassWordKey") ?? ""
    let params: [String: Any] = ["username": userValue  as Any, "password": passWordValue as Any]
    var request  = URLRequest(url: URL(string: "https://www.stablehelpdesk.faveodemo.com")!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("token", forHTTPHeaderField: "Authorization")
    do {
    request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
    } catch let error
    {
        print("params boday error \(error)")
    }
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        
        if let jsonData = data, let lResponse  = response as? HTTPURLResponse {
            do {
                print("status code \(lResponse.statusCode)")
        var userData = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String:Any]
                print(userData)
                let data:[String:Any] = userData?["data"] as! [String : Any]
                if userData?["success"] != nil && userData?["data"] != nil
                {
                    let successValue:Int = userData?["success"] as! Int
                    print(successValue)
                    if successValue == 1  {
                        let tokenValue = data["token"]!
                        UserDefaults.standard.set(tokenValue, forKey: "TokenKey")  //Integer
                        UserDefaults.standard.synchronize()
                    }else {
                        print("Authentication is failed ")
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
    }.resume()

}
