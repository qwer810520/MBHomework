//
//  TransactionDetailTableViewCell.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/7.
//

import UIKit
import SnapKit

class TransactionDetailTableViewCell: UITableViewCell {

  private lazy var nameLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.numberOfLines = 0
    return label
  }()

  private lazy var priceLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.textAlignment = .right
    label.numberOfLines = 0
    return label
  }()

  var cellModel: TransactionListCellViewObject? {
    didSet {
      guard let data = cellModel else { return }
      nameLabel.text = data.name
      priceLabel.text = data.priceWithQuantity
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
    setupAutoLayout()
  }

  private func setupAutoLayout() {
    nameLabel.snp.makeConstraints {
      $0.top.bottom.left.equalToSuperview()
      $0.width.equalTo(contentView.frame.width / 2)
    }

    priceLabel.snp.makeConstraints {
      $0.top.bottom.right.equalToSuperview()
      $0.left.equalTo(nameLabel.snp.right)
    }
  }
}
