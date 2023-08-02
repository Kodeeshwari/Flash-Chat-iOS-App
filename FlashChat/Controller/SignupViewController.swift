//
//  SignupViewController.swift
//  FlashChat
//
//  Created by Kodeeshwari Solanki on 2023-07-27.
//

import UIKit
import FirebaseAuth

class SignupViewController: UIViewController {

    @IBOutlet var txtEmail : UITextField!
    
    @IBOutlet var txtPassword : UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnSignUpTouchUpInside(_ sender: Any) {
        
        if let email = txtEmail.text, let password = txtPassword.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print(e.localizedDescription)
                }
                else{
                    self.performSegue(withIdentifier: Constants.registerSegue, sender: nil)
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
