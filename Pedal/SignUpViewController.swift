//
//  SignUpViewController.swift
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

class SignUpViewController: UIViewController,ValidationDelegate {
    
    let validator = Validator()
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var lName: UITextField!
    @IBOutlet weak var lNameErrorLabel: UILabel!
    @IBOutlet weak var phNumber: UITextField!
    @IBOutlet weak var phNumberErrorLabel: UILabel!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var genderErrorLabel: UILabel!
    @IBOutlet weak var birthdate: UIDatePicker!
    @IBOutlet weak var birthdateErrorLabel: UILabel!
    @IBOutlet weak var aadhar: UITextField!
    @IBOutlet weak var aadharErrorLabel: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var streetErrorLabel: UILabel!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var stateErrorLabel: UILabel!
    @IBOutlet weak var cityErrorLabel: UILabel!
    @IBOutlet weak var pincode: UITextField!
    @IBOutlet weak var pincodeErrorLabel: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register fields for validation
        
       /* validator.registerField(name, errorLabel: nameErrorLabel, rules: [RequiredRule()])
        validator.registerField(lName, errorLabel: lNameErrorLabel, rules: [RequiredRule()])
        validator.registerField(phNumber, errorLabel: phNumberErrorLabel, rules: [RequiredRule(),MinLengthRule(length:9)])
        validator.registerField(gender, errorLabel: genderErrorLabel, rules: [RequiredRule()])
        validator.registerField(birthdate, errorLabel: birthdateErrorLabel, rules: [RequiredRule(),MinLengthRule(length:10)])
        validator.registerField(aadhar, errorLabel: aadharErrorLabel, rules: [RequiredRule(),MinLengthRule(length:12)])
        validator.registerField(email, errorLabel: emailErrorLabel, rules: [EmailRule(message: "Invalid email")])
        validator.registerField(street, errorLabel: streetErrorLabel, rules: [RequiredRule()])
        validator.registerField(city, errorLabel: cityErrorLabel, rules: [RequiredRule()])
        validator.registerField(state, errorLabel: stateErrorLabel, rules: [RequiredRule()])
        validator.registerField(pincode, errorLabel: pincodeErrorLabel, rules: [RequiredRule()])
        validator.registerField(password, errorLabel: passwordErrorLabel, rules: [RequiredRule(),MinLengthRule(length:6)])
        
        validator.unregisterField(name)
        validator.unregisterField(lName)*/
    }
    
      //if inputs are correct
    func validationSuccessful() {
        // submit the form
        var date = birthdate.date.timeIntervalSince1970  //change date to unix epoch
        
  //pass user details entered to /signup
        userDetails(name.text!,lName.text!,phNumber.text!,gender.text!,date,aadhar.text!,email.text!,street.text!,city.text!,state.text!,pincode.text!,password.text!)

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

extension SignUpViewController{
    
    func userDetails(_ name: String,_ lName: String,_ phNumber: String,_ gender: String,_ birthdate: TimeInterval,_ aadhar: String,_ email: String,_ street: String,_ city: String,_ state: String,_ pincode: String,_ password: String) {
        
        let parameters : Parameters = [
            "user":[
            "firstName" :  name,
            "lastName" : lName,
            "phoneNumber" : phNumber,
            "gender" : gender,
            "birthDate" : birthdate,
            "aadharNumber": aadhar,
            "email" : email,
            "permanentAddress" :[
                "street" : street,
                "city": city,
                "state" : state,
                "pincode" : pincode
            ]
            ],
            "password" : password
        ]
        
        //send request to /signup to register user
        Alamofire.request("http://52.163.120.124:8080/auth/signup", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ response in
            
            print(response.request!)  // original URL request
           
            switch response.result{
            case .success(let value):
                let JsonData = JSON(value)
                
                //for later use
                guard let userId = JsonData["userId"].string else{
                    print(JsonData["userId"])
                    return
                }
                
                guard let role = JsonData["role"].string else{
                    print(JsonData["role"])
                    return
                }
                guard let verified = JsonData["verified"].bool else{
                    print(JsonData["verified"])
                    return
                }
                
                //if user is registered but not verified, go to verification
                if verified == false{
                let controller : OTPViewController
                controller = self.storyboard?.instantiateViewController(withIdentifier: "otp") as! OTPViewController
                    
                    //pass userId and password for verification
                    controller.userID = userId
                    controller.password = password
                    self.present(controller, animated: true, completion: nil)
                }
                else{
                    print("cannot signup user")
                }
                
                //user is already registered
            case .failure(let error):
                print(error.localizedDescription)
               
            }
        }
    }
}
