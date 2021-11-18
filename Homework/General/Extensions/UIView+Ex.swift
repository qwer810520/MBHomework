//
//  UIView+Ex.swift
//  Homework
//
//  Created by Min on 2021/11/18.
//

import UIKit

extension UIView {
  func addSubviews(_ views: [UIView]) {
    views.forEach { addSubview($0) }
  }
}
