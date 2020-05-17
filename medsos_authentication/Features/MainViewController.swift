//
//  ViewController.swift
//  medsos_authentication
//
//  Created by yoviekaputra on 17/05/20.
//  Copyright © 2020 gyosanila. All rights reserved.
//

import UIKit
import GoogleSignIn

class MainViewController: BaseViewController {
    @IBOutlet weak var btnGoogleSignin: AuthButton!
    @IBOutlet weak var btnFacebookSignin: AuthButton!
    @IBOutlet weak var lblProfile: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObserver()
        setupData()
        setupUI()
    }
    
    private func setupData() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }

    private func setupObserver() {
        NotificationCenter.default.addObserver(forName: .GoogleSign, object: nil, queue: nil) { notif in
            if let data = notif.object {
                switch data {
                case is GIDGoogleUser:
                    self.googleSignInHandling(data: data as! GIDGoogleUser)
                default:
                    print("not wraped")
                }
            }
        }
    }
    
    private func setupUI() {
        imgAvatar.layer.cornerRadius = imgAvatar.frame.height / 2
        imgAvatar.layer.borderColor = UIColor.white.cgColor
        imgAvatar.layer.borderWidth = 1
    }
}

extension MainViewController {
    @IBAction func googleSignIn(_ sender: Any) {
        if btnGoogleSignin.titleLabel?.text == "Logout" {
            GIDSignIn.sharedInstance().signOut()
            self.lblProfile.text = ""
            self.imgAvatar.image = nil
            self.btnGoogleSignin.setTitle("Google SignIn", for: .normal)
        } else {
            GIDSignIn.sharedInstance().signIn()
        }
    }
}

extension MainViewController {
    private func googleSignInHandling(data: GIDGoogleUser) {
        self.btnGoogleSignin.setTitle("Logout", for: .normal)
        lblProfile.text = "User ID : \(data.userID ?? "")\n"
        lblProfile.text?.append("Name : \(data.profile.name ?? "")\n")
        lblProfile.text?.append("Give Name : \(data.profile.givenName ?? "")\n")
        lblProfile.text?.append("Family Name : \(data.profile.familyName ?? "")\n")
        lblProfile.text?.append("Email : \(data.profile.email ?? "")\n")
        lblProfile.text?.append("Has Image : \(data.profile.hasImage)\n")
        if data.profile.hasImage,
            let url = data.profile.imageURL(withDimension: 100)?.absoluteString{
            imgAvatar.load(fromUrl: url)
        }
        print("clientID   : \(data.authentication.clientID ?? "")\n")
        print("idToken    : \(data.authentication.idToken ?? "")")
        print("refreshToken: \(data.authentication.refreshToken ?? "")")
    }
}
