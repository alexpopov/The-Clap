//
//  NavigationController.swift
//  The Clap
//
//  Created by Alex Popov on 2016-02-27.
//  Copyright © 2016 Numbits. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//      navigationBar.clipsToBounds = true
      navigationBar.translucent = false
//      navigationBar.setBackgroundImage(UIImage(named: "tabbar"), forBarMetrics: .Default)
      navigationBar.barTintColor = Colour.Blue.color
      navigationBar.tintColor = Colour.White.color
      navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : Colour.White.color]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
