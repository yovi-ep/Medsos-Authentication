//
//  AuthenticationViewController.swift
//  medsos_authentication
//
//  Created by yoviekaputra on 17/05/20.
//  Copyright © 2020 gyosanila. All rights reserved.
//

import UIKit
import GoogleSignIn

class AuthenticationViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
}
