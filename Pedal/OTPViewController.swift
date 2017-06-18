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
    @IBOutlet weak var wrongOTP: UILabel!
    @IBOutlet weak var resendOTP: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         // register field for validation
        validator.registerField(otp, errorLabel: otpErrorLabel, rules: [RequiredRule(),MinLengthRule(length:4)])
        self.resendOTP.isEnabled = false
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(enableResend), userInfo: nil, repeats: true)
    }
    
    //if inputs are correct
    func validationSuccessful() {
        // submit the form
        otpErrorLabel.isHidden = true
          //pass otp entered to /verify
        verifyUser(otp.text!)
    }
    
    //if inputs are cinorrect
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        // turn the fields to red
        for (field, error) in validator.errors {
            error.errorLabel?.text = error.errorMessage
            error.errorLabel?.isHidden = false
        }
    }
    
    //enable resend OTP after 60sec
    func enableResend(){
        self.resendOTP.isEnabled = true
    }
    
    //check if inputs are correct
    @IBAction func sendPressed(_ sender: Any) {
        validator.validate(self)
        self.wrongOTP.text = "" //empty the wrongOTP field
    }
    
    //resend the otp
    @IBAction func resendPressed(_ sender: Any) {
        resend()
    }
    
}
extension OTPViewController{
    
    func verifyUser(_ sender: String) {
        
        let parameters : Parameters = [
            "userId" :  userID,
            "token" : sender
        ]
                //send request to /verify to verify user
        Alamofire.request("http://52.163.120.124:8080/auth/verify", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ response in
            
            print(response.request!)  // original URL request
            
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
                    //check userId and password and then log user in
                    LogInViewController().checkLogin(self.userID,self.password)
                    }
                    else{
                    print("verification failed")
                }
            
                //if invalid otp is entered
            case .failure(let error):
                print(error.localizedDescription)
                 self.wrongOTP.text = "Invalid OTP"
                
            }
       }
    }
    
    func  resend() {
        let parameters : Parameters = [
            "userId" :  userID
            ]
        //send request to /verify/resend to resend otp
        Alamofire.request("http://52.163.120.124:8080/auth/verify/resend", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ response in
            
            print(response.request!)  // original URL request
            
            switch response.result{
            case .success(let value):
              print("OTP send")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
   }
}
