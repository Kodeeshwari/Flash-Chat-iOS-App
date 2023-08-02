//
//  ViewController.swift
//  FlashChat
//
//  Created by Kodeeshwari Solanki on 2023-07-26.
//

import UIKit
import CLTypingLabel

class ViewController: UIViewController {
    
    @IBOutlet weak var lblTitleText: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* text animation
         
         lblTitleText.text = ""
         let titleText = "⚡️FlashChat"
         var charIndex = 0.0
         for letter in titleText{
         Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { timer in
         self.lblTitleText.text?.append(letter)
         }
         charIndex+=1
         }
         */
        
        lblTitleText.text = Constants.appName
        lblTitleText.charInterval = 0.08
        
        
    }
    
    
    
    
}

