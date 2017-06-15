//
//  PasswordViewController.swift
//  Pedal
//
//  Created by Anurita Srivastava on 15/06/17.
//  Copyright © 2017 Anurita Srivastava. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var userID : String!

    @IBOutlet weak var password: UITextField!
    @IBAction func getPassword(_ sender: Any) {
        let parameters : Parameters = [
                "userId" :  userID,
                "password" : password.text!
        ]
        Alamofire.request("http://52.163.120.124:8080/auth/login", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ response in
        
        print(response.request)  // original URL request
        if response.data != nil{
            
            
            let JsonData = JSON(response.data!)
            
            guard let user = JsonData["user"].dictionary else{
                print(JsonData["user"])
                return
            }
            
            guard let userId = user["userId"]?.string else{
                print(user["userId"])
                return
            }
            guard let role = user["role"]?.string else{
                print(user["role"])
                return
            }
            
            guard let token = JsonData["token"].string else{
                print(JsonData["token"])
                return
            }
print("welcome to home")

        }
        
        }
    }


}
