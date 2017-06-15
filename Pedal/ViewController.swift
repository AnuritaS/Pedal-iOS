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

class ViewController: UIViewController {

   
    @IBOutlet weak var phNumber: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
   

    @IBAction func sendPressed(_ sender: Any) {
        self.getID(phNumber.text!)
    }
    
    
} //9962701152

extension ViewController{
    
    func showError(_ error: String){
        print(error)
    }
    
    func getID(_ phNumber : Any){
        Alamofire.request("http://52.163.120.124:8080/auth/query?phoneNumber=\(phNumber)").responseJSON{response in
            print(response.request)  // original URL request
                  if response.data != nil{
                    
                 
            let JsonData = JSON(response.data!)
                   
                    guard let verify = JsonData["verified"].bool else{
                        self.showError("\(JsonData["verified"])")
                        return
                    }
                    
                    guard let id = JsonData["_id"].string else{
                         self.showError("\(JsonData["_id"])")
                        return
                    }
                    
                    if verify == true{
                        let controller : PasswordViewController
                        
                        controller = self.storyboard?.instantiateViewController(withIdentifier: "password") as!PasswordViewController
                        controller.userID = id
                        self.present(controller, animated: true, completion: nil)
                        print("Pass to getPassword")
                    }else{
                        print("signup")
                    }
                  
        }
    }
}
   
}


