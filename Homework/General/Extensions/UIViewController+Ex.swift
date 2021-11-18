//
//  UIViewController+Ex.swift
//  Homework
//
//  Created by Min on 2021/11/18.
//

import UIKit

extension UIViewController {
  var navigationMaxY: CGFloat {
    return navigationController?.navigationBar.frame.maxY ?? 0
  }
}
