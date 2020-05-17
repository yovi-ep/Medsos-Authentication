//
//  AuthButton.swift
//  medsos_authentication
//
//  Created by yoviekaputra on 17/05/20.
//  Copyright © 2020 gyosanila. All rights reserved.
//

import UIKit

class AuthButton : UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = self.frame.height * 0.1
    }
}
