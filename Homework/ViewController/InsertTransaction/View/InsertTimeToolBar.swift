//
//  InsertTimeToolBar.swift
//  Homework
//
//  Created by Min on 2021/11/19.
//

import UIKit

class InsertTimeToolBar: UIToolbar {

  private(set) var cancelButtonItem: UIBarButtonItem = {
    return UIBarButtonItem(title: "Concel", style: .plain, target: nil, action: nil)
  }()

  private var spaceButtonItem: UIBarButtonItem = {
    return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
  }()

  // MARK: - Initialization

  init() {
    super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    setUserInterface()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private Method

  private func setUserInterface() {
    barStyle = .default
    isTranslucent = true
    sizeToFit()
    items = [cancelButtonItem, spaceButtonItem]
    isUserInteractionEnabled = true
  }
}
