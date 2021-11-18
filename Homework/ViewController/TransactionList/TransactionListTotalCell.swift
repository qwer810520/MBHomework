//
//  TransactionListTotalCell.swift
//  Homework
//
//  Created by Min on 2021/11/18.
//

import UIKit
import SnapKit

class TransactionListTotalCell: UITableViewCell {
  private lazy var nameLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.numberOfLines = 1
    label.text = "Total"
    return label
  }()

  private lazy var priceLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.numberOfLines = 1
    return label
  }()

  var total: Int? {
    didSet {
      guard let total = total else { return }
      priceLabel.text = "$\(total)"
    }
  }

  // MARK: - Initialization

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUserInterface()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private Methods

  private func setupUserInterface() {
    contentView.addSubviews([nameLabel, priceLabel])
    setupAutolayout()
  }

  private func setupAutolayout() {
    nameLabel.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.left.equalToSuperview().inset(8)
      $0.width.equalToSuperview().multipliedBy(0.5)
    }

    priceLabel.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.right.equalToSuperview().inset(8)
      $0.width.equalToSuperview().multipliedBy(0.5)
    }
  }
}
