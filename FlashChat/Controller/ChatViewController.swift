//
//  ChatViewController.swift
//  FlashChat
//
//  Created by Kodeeshwari Solanki on 2023-07-27.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var txtChatBox: UITextField!
    
    let db = Firestore.firestore()
    
    var messages : [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.title = Constants.appName
        
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages(){
        
        db.collection(Constants.Fstore.collectionName)
            .order(by: Constants.Fstore.dateField)
            .addSnapshotListener() { (querySnapshot, err) in
            self.messages = []
            if let err = err {
                print("Error getting messages: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let messageSender = data[Constants.Fstore.senderField] as? String, let messageBody = data[Constants.Fstore.bodyField] as? String{
                        let newMessage = Message(sender: messageSender, body: messageBody)
                        self.messages.append(newMessage)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnLogoutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    
    @IBAction func btnSendPressed(_ sender: Any) {
        
        if let messageBody = txtChatBox.text, let messageSender = Auth.auth().currentUser?.email{
            db.collection(Constants.Fstore.collectionName).addDocument(data:[
                Constants.Fstore.senderField: messageSender,
                Constants.Fstore.bodyField: messageBody,
                Constants.Fstore.dateField: Date().timeIntervalSince1970
            ]){ (error) in
                if let e = error {
                    print("There was an issue saving data to firestore,\(e.localizedDescription)")
                }
                else{
                    print("Successfully saved data.")
                    DispatchQueue.main.async {
                        self.txtChatBox.text = ""
                    }
                }
            }
        }
    }
}


extension ChatViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageTableViewCell
        cell.messageLabel.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.rightImageView.tintColor = UIColor(named: "darkPurple")
            cell.messageBubble.backgroundColor = UIColor(named:"darkPurple")
            cell.messageLabel.textColor = UIColor(ciColor: .white)
        }
        else{
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.leftImageView.tintColor = UIColor(named: "lightPurple")
            cell.messageBubble.backgroundColor = UIColor(named:"lightPurple")
            cell.messageLabel.textColor = UIColor(named: "darkPurple")
        }
        return cell
    }
    
}
