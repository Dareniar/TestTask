//
//  SignUpViewController.swift
//  Test Task
//
//  Created by Данил on 9/11/18.
//  Copyright © 2018 Dareniar. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController {
    
    let url = "https://apiecho.cf"
    var text: String?

    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var emailTextBox: UITextField!
    @IBOutlet weak var passwordTextBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        let parameters: [String:String] = ["name" : nameTextBox.text!, "email": emailTextBox.text!, "password": passwordTextBox.text! ]
        
        let signUpURL = url + "/api/signup/"
        
        obtainAccessToken(url: signUpURL, parameters: parameters)
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        
        let parameters: [String:String] = ["email": emailTextBox.text!, "password": passwordTextBox.text! ]
        
        let logInURL = url + "/api/login/"
        
        obtainAccessToken(url: logInURL, parameters: parameters)
    }
    
    //MARK: - Task 1 (Obtain access_token)
    
    func obtainAccessToken(url: String, parameters: [String:String]) {
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                
                guard let json = response.result.value as? NSDictionary, let data = json["data"] as? [String:Any] else { return }
                
                print(response.result.value!)
                
                guard let accessToken = data["access_token"] as? String else { return }
                
                self.getText(with: accessToken, of: "en")
                
            } else {
                print("Error \(String(describing: response.result.error)).")
            }
        }
    }
    
    //MARK: - Task 2 (Fetch Text for locale)
    
    func getText(with accessToken: String, of locale: String) {
    
        let getTextURL = "https://apiecho.cf/api/get/text/"
        let header = ["Authorization": "Bearer \(accessToken)"]
        let parameter = ["Locale": locale]
        
        Alamofire.request(getTextURL, method: .get, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.isSuccess {
                
                guard let json = response.result.value as? NSDictionary, let data = json["data"] as? String else { return }
                self.text = data
                self.performSegue(withIdentifier: "resultSegue", sender: nil)
                
            } else {
                print("Error \(String(describing: response.result.error)).")
            }
        }
    }
    
    //MARK: - Task 3 (Count occurance of each character)
    
    func calculateCharacters(from text: String) -> [Character: Int] {
        
        var characters = [Character: Int]()
        for letter in text.uppercased() {
            if characters[letter] != nil {
                characters[letter]! += 1
            } else {
                characters[letter] = 1
            }
        }
        return characters
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CharacterTableViewController, let text = text {
            destination.characters = calculateCharacters(from: text)
        }
    }
}
