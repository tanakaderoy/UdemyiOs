//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import ChameleonFramework


class ChatViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
  
    
    // Declare instance variables here
    var messageArray = [Message]()
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        //TODO: Set yourself as the delegate and datasource here:
        
        messageTableView.delegate = self
        //TODO: Set yourself as the delegate of the text field here:
        messageTableView.dataSource = self
        messageTextfield.delegate = self
        
        
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
         messageTableView.addGestureRecognizer(tapGesture)
        
        

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView()
        retrieveMessage()
        messageTableView.separatorStyle = .none
        
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        if cell.senderUsername.text == Auth.auth().currentUser?.email{
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
            
        }else{
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        return cell
    }
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    
    func configureTableView(){
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    //TODO: Declare numberOfRowsInSection here:
    
    
    
    //TODO: Declare tableViewTapped here:
    
    
    
    
    //TODO: Declare configureTableView here:
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    var keyboardHeight : CGFloat = 0.0
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardHeight = keyboardSize.height
            //print(keyboardHeight)
        }
    }
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = self.heightConstraint.constant + self.keyboardHeight
            self.view.layoutIfNeeded()
        }
    }

    
    //TODO: Declare textFieldDidBeginEditing here:
    
    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 58
            self.view.layoutIfNeeded()
        }
    }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        messageTextfield.endEditing(true)
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        let messagesDB = Database.database().reference().child("Messages")
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody": messageTextfield.text!]
        messagesDB.childByAutoId().setValue(messageDictionary){
            (error, reference) in
            if error != nil{
                print(error!)
                
                } else {
                self.messageTextfield.text = ""
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
            }
        }
        
        //TODO: Send the message to Firebase and save it in our database
        
        
    }
    
    //TODO: Create the retrieveMessages method here:
    func retrieveMessage(){
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            let message = Message()
            message.messageBody = text
            message.sender = sender
            self.messageArray.append(message)
            self.configureTableView()
            self.messageTableView.reloadData()
        }
    }
    
    

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let error as Error {
            print(error)
        }
        //TODO: Log out the user and send them back to WelcomeViewController
        
        
    }
    


}
