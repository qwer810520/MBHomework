//
//  UITableView+Ex.swift
//  Homework
//
//  Created by Min on 2021/11/18.
//

import UIKit

extension UITableView {
  func reguster(with cells: [UITableViewCell.Type]) {
    cells.forEach { register($0.self, forCellReuseIdentifier: $0.identifier) }
  }

  func dequeueReusableCell<T: UITableViewCell>(with cell: T.Type, indexPath: IndexPath) -> T {
    guard let customCell = dequeueReusableCell(withIdentifier: cell.identifier, for: indexPath) as? T else {
      fatalError("\(cell.identifier) Initialization fail")
    }
    return customCell
  }
}
