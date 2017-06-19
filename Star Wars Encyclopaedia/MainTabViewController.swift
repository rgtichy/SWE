//
//  MainTabViewController.swift
//  Star Wars Encyclopaedia
//
//  Created by Robert G Tichy on 6/18/17.
//  Copyright © 2017 Robert G Tichy. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedViewController = self.viewControllers?[1]
    }
}
