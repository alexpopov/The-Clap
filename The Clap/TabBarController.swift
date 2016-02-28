//
//  TabBarController.swift
//  The Clap
//
//  Created by Alex Popov on 2016-02-27.
//  Copyright © 2016 Numbits. All rights reserved.
//

import UIKit
import Prelude

class TabBarController: UITabBarController {

  lazy var findViewController = UIViewController()
  lazy var listViewController = UIViewController()
  lazy var settingsViewController = UIViewController()

  enum Tabs: Int {
    case Find, List, Settings

    static var allCases: [Tabs] {
      var i = 0
      var cases = [Tabs]()
      while let tab = Tabs(rawValue: i) {
        cases.append(tab)
        i += 1
      }
      return cases
    }

    var name: String {
      switch self {
      case .Find: return "Find"
      case .List: return "List"
      case .Settings: return "Settings"
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    viewControllers = Tabs.allCases.map { tab in
      let viewController = self.viewControllerForTab(tab)
      let navController = NavigationController(rootViewController: viewController)
      navController.tabBarItem.title = tab.name
      viewController.view.backgroundColor = Colour.Blue.color
      return navController
    }
    tabBar.translucent = false
    tabBar.tintColor = Colour.White.color
    tabBar.backgroundImage = UIImage(named: "tabbar")
    tabBar.shadowImage = UIImage()
    tabBar.clipsToBounds = true
  }

  func viewControllerForTab(tab: Tabs) -> UIViewController {
    switch tab {
    case .Find:
      return findViewController
    case .List:
      return listViewController
    case .Settings:
      return settingsViewController
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }




}
