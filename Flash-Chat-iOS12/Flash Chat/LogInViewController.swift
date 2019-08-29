//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import FirebaseAuth
import SVProgressHUD


class LogInViewController: UIViewController{

    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    @IBAction func logInPressed(_ sender: AnyObject) {
        SVProgressHUD.show()
        if let email = emailTextfield.text, let password = passwordTextfield.text{
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil{
                
            }else{
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
                
            }
        }
        }
        
        //TODO: Log in the user
        
        
    }
    


    
}  
