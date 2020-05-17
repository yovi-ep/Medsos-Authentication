//
//  ViewController.swift
//  medsos_authentication
//
//  Created by yoviekaputra on 17/05/20.
//  Copyright © 2020 gyosanila. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {

    @IBAction func btnAuthentication(_ sender: Any) {
        let controller = AuthenticationViewController.initFromXIB()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

