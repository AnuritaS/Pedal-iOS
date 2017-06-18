//
//  ViewController.swift
//  Pedal
//
//  Created by Anurita Srivastava on 10/06/17.
//  Copyright © 2017 Anurita Srivastava. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftValidator
import Crashlytics

class ViewController: UIViewController,ValidationDelegate {

    let validator = Validator()
    @IBOutlet weak var phNumber: UITextField!
    @IBOutlet weak var phNumberErrorLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //register field for validation
        validator.registerField(phNumber, errorLabel: phNumberErrorLabel, rules: [RequiredRule(),MinLengthRule(length:10)])
       
    }
    
    //if inputs are correct
    func validationSuccessful() {
        // submit the form
         phNumberErrorLabel.isHidden = true
        //pass phone number entered to /query
         self.getID(phNumber.text!)
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

extension ViewController{
    
    func getID(_ phNumber : String){
        
        //send request to /query to check phone number
        Alamofire.request("http://52.163.120.124:8080/auth/query?phoneNumber=\(phNumber)").responseJSON{response in
            
            print(response.request!) // original URL request
            
            switch response.result{
            case .success(let value):
                let JsonData = JSON(value)
                
                guard let verify = JsonData["verified"].bool else{
                    print(JsonData["verified"])
                    return
                }
                
                guard let id = JsonData["userId"].string else{
                    print(JsonData["userId"])
                    return
            }
                //if user is present and verified, go to login
                if verify{
                    
                    let controller : LogInViewController
                    controller = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LogInViewController
                    controller.userID = id
                    self.present(controller, animated: true, completion: nil)
                    print("Pass to LogIn")
                    
                }//if user is present but not verified, verify user
                else{
                    
                    let controller : OTPViewController
                    controller = self.storyboard?.instantiateViewController(withIdentifier: "otp") as! OTPViewController
                    controller.userID = id
                    self.present(controller, animated: true, completion: nil)
                    print("Pass to Verification")
                }
                
                //if user is not present, go to signup
            case .failure(let error):
                print(error.localizedDescription)
                
                let controller : SignUpViewController
                controller = self.storyboard?.instantiateViewController(withIdentifier: "signup") as! SignUpViewController
                // controller.phNumber.text = phNumber to autofill phone number
                self.present(controller, animated: true, completion: nil)
                print("Pass to SignUp")
                
        }
     }
  }
}


