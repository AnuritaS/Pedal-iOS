//
//  OTPViewController.swift
//  Pedal
//
//  Created by Anurita Srivastava on 18/06/17.
//  Copyright © 2017 Anurita Srivastava. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Crashlytics
import SwiftValidator

class OTPViewController: UIViewController,ValidationDelegate {
    
    let validator = Validator()
    
    var userID : String!
    var password : String!
    @IBOutlet weak var otp: UITextField!
    @IBOutlet weak var otpErrorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        validator.registerField(otp, errorLabel: otpErrorLabel, rules: [RequiredRule(),MinLengthRule(length:4)])
        
    }
    
    
    func validationSuccessful() {
        // submit the form
        otpErrorLabel.isHidden = true
        checkLogin(otp.text!)
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        // turn the fields to red
        for (field, error) in validator.errors {
            error.errorLabel?.text = error.errorMessage
            error.errorLabel?.isHidden = false
        }
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        validator.validate(self)
        
    }
    
    @IBAction func resendPressed(_ sender: Any) {
    }
    
    func checkLogin(_ sender: String) {
        let parameters : Parameters = [
            "userId" :  userID,
            "token" : sender
        ]
        Alamofire.request("http://52.163.120.124:8080/auth/verify", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ response in
            
            print(response.request)  // original URL request
            switch response.result{
            case .success(let value):
                let JsonData = JSON(value)
                guard let userId = JsonData["userId"].string else{
                    print(JsonData["userId"])
                    return
                }
                
                guard let verified = JsonData["verified"].bool else{
                    print(JsonData["verified"])
                    return
                }
                if verified{
                    
                    print("Welcome to home")
                }else{
                    print("failed to check otp")
                }

            case .failure(let error):
                print("user not verified")
                print(error)
            }
            
            
        }
        
            }
            
        }

