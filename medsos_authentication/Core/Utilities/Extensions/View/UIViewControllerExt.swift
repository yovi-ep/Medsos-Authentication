//
//  UIViewControllerExt.swift
//  medsos_authentication
//
//  Created by yoviekaputra on 17/05/20.
//  Copyright © 2020 gyosanila. All rights reserved.
//

import UIKit

extension UIViewController {
    static func initFromXIB() -> Self {
        return Self.init(nibName: "\(self)", bundle: nil)
    }
}
