//
//  HWNavigationController.swift
//  Homework
//
//  Created by Min on 2021/11/18.
//

import UIKit

class HWNavigationController: UINavigationController {

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUserInterface()
  }

  // MARK: - Private Methods

  private func setupUserInterface() {
    if #available(iOS 15, *) {
      let appearance = UINavigationBarAppearance()
      appearance.configureWithDefaultBackground()
      navigationBar.standardAppearance = appearance
      navigationBar.scrollEdgeAppearance = appearance
    }
  }
}
