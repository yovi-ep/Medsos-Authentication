//
//  AuthenticationViewController.swift
//  medsos_authentication
//
//  Created by yoviekaputra on 17/05/20.
//  Copyright © 2020 gyosanila. All rights reserved.
//

import UIKit
import GoogleSignIn

class DetailAccountViewController: UIViewController {
    
    @IBOutlet weak var btnGoogleSignin: UIButton!
    private var isGoogleSignin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupObserver()
    }
    
    private func setupData() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        btnGoogleSignin.setTitle("SignIn with Google", for: .normal)
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(forName: .GoogleSign, object: nil, queue: nil) { notif in
            if let data = notif.object {
                let user = data as? GIDGoogleUser
                print(user?.profile.email)
                self.isGoogleSignin = true
                self.btnGoogleSignin.setTitle("Logout Google", for: .normal)
            } else {
                self.isGoogleSignin = false
                self.btnGoogleSignin.setTitle("SignIn with Google", for: .normal)
            }
        }
    }
  
    @IBAction func googleSignIn(_ sender: Any) {
        if isGoogleSignin {
            GIDSignIn.sharedInstance().signOut()
        } else {
            GIDSignIn.sharedInstance().signIn()
        }
    }
}
