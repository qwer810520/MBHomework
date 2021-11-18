//
//  TransactionListSectionView.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/6.
//

import UIKit

protocol TransactionListSectionDelegate: class {
  func deleteButtonDidPressed(with id: Int)
}

class TransactionListSectionView: UIView {

  private lazy var titleLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.textColor = .white
    label.numberOfLines = 1
    return label
  }()

  private lazy var timeLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.textAlignment = .right
    label.textColor = .white
    label.numberOfLines = 1
    return label
  }()

  lazy private var deleteButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .systemRed
    button.setTitle("X", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 4
    button.addTarget(self, action: #selector(deleteButtonDidPressed), for: .touchUpInside)
    return button
  }()

  weak var delegate: TransactionListSectionDelegate?
  private let id: Int

  // MARK: - Initialization

  init(frame: CGRect, transactionListItemViewObject: TransactionListSectionViewObject, delegate: TransactionListSectionDelegate? = nil) {
    self.delegate = delegate
    self.id = transactionListItemViewObject.transactionData.id
    super.init(frame: frame)

    titleLabel.text = transactionListItemViewObject.title
    timeLabel.text = transactionListItemViewObject.time

    addSubviews([titleLabel, timeLabel, deleteButton])
    backgroundColor = UIColor.black

    titleLabel.snp.makeConstraints { (make) in
      make.top.bottom.equalToSuperview()
      make.left.equalToSuperview().inset(8)
      make.width.equalToSuperview().multipliedBy(0.4)
    }

    timeLabel.snp.makeConstraints { (make) in
      make.top.bottom.equalToSuperview()
      make.right.equalTo(deleteButton.snp.left).offset(-5)
      make.left.equalTo(titleLabel.snp.right)
    }

    deleteButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(5)
      $0.bottom.equalToSuperview().offset(-5)
      $0.right.equalToSuperview().inset(8)
      $0.width.equalTo(34)
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Action Methods

  @objc private func deleteButtonDidPressed() {
    delegate?.deleteButtonDidPressed(with: id)
  }
}
