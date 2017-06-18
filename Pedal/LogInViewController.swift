//
//  LogInViewController.swift
//  Pedal
//
//  Created by Anurita Srivastava on 15/06/17.
//  Copyright © 2017 Anurita Srivastava. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Crashlytics
import SwiftValidator

class LogInViewController: UIViewController,ValidationDelegate {

    let validator = Validator()
    
    var userID : String!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // register field for validation
        validator.registerField(password, errorLabel: passwordErrorLabel, rules: [RequiredRule(),MinLengthRule(length:6)])
        
    }
    
    //if inputs are correct
    func validationSuccessful() {
        // submit the form
        passwordErrorLabel.isHidden = true
        //pass password entered to /login
        checkLogin(userID,password.text!)
    }
    
    //if inputs are incorrect
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        // turn the fields to red
        for (field, error) in validator.errors {
            error.errorLabel?.text = error.errorMessage
            error.errorLabel?.isHidden = false
        }
    }
    
    //check if inputs are correct
    @IBAction func sendPressed(_ sender: Any) {
        validator.validate(self)
        
    }
}

extension LogInViewController{
    
    func checkLogin(_ userId: String,_ password: String) {
        
        let parameters : Parameters = [
                "userId" :  userId,
                "password" : password
        ]
        
        //send request to /login to check credentials
        Alamofire.request("http://52.163.120.124:8080/auth/login", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ response in
        
        print(response.request!)  // original URL request
            
            //for later use
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
            
            
            /*var controller : HomeViewController
            controller = self.storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController
            self.present(controller, animated: true, completion: nil)*/
            print("Pass to Home")
            
            }
        }
    }

}
