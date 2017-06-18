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
        // Do any additional setup after loading the view, typically from a nib.
        validator.registerField(phNumber, errorLabel: phNumberErrorLabel, rules: [RequiredRule(),MinLengthRule(length:10)])
       
    }
    
    
    func validationSuccessful() {
        // submit the form
         phNumberErrorLabel.isHidden = true
         self.getID(phNumber.text!)
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
    
} //9962701152

extension ViewController{
    
    func getID(_ phNumber : String){
        Alamofire.request("http://52.163.120.124:8080/auth/query?phoneNumber=\(phNumber)").responseJSON{response in
            print(response.request)  // original URL request
                 /* if response.data != nil{
                    
                 
            let JsonData = JSON(response.data!)
                   
                    guard let verify = JsonData["verified"].bool else{
                        self.showError("\(JsonData["verified"])")
                        return
                    }
                    
                    guard let id = JsonData["userId"].string else{
                         self.showError("\(JsonData["userId"])")
                        return
                    }*/
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
                print(id)
                if verify{
                    let controller : LogInViewController
                    
                    controller = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LogInViewController
                    controller.userID = id
                    self.present(controller, animated: true, completion: nil)
                    print("Pass to LogIn")
                }else{
                    let controller : OTPViewController
                    controller = self.storyboard?.instantiateViewController(withIdentifier: "otp") as! OTPViewController
                    controller.userID = id
                    self.present(controller, animated: true, completion: nil)
                }
            case .failure(let error):
                let controller : SignUpViewController
                controller = self.storyboard?.instantiateViewController(withIdentifier: "signup") as! SignUpViewController
                // controller.phNumber.text = phNumber
                self.present(controller, animated: true, completion: nil)
                print("Pass to SignUp")
                print(error)
                
        }
    }
}
   
}


