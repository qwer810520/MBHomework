//
//  TransactionDetailViewController.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/7.
//

import UIKit
import SnapKit

class TransactionDetailViewController: UIViewController {

//  #warning("DOTO: Transaction Detail ")

  private lazy var titleLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.numberOfLines = 0
    return label
  }()

  private lazy var timeLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.numberOfLines = 0
    return label
  }()

  private lazy var descriptionLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.numberOfLines = 0
    return label
  }()

  private lazy var detailTableView: UITableView = {
    let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.reguster(with: [TransactionDetailTableViewCell.self])
    return tableView
  }()

  // MARK: - UIViewController

  private let detailInfo: TransactionListSectionViewObject

  init(transactionInfo: TransactionListSectionViewObject) {
    self.detailInfo = transactionInfo
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUserInterface()
  }

  // MARK: - Private Methods

  private func setupUserInterface() {
    navigationItem.title = "Detail"
    view.backgroundColor = .white
    view.addSubviews([titleLabel, timeLabel, descriptionLabel, detailTableView])
    setupAutoLayout()

    titleLabel.text = "Title: \(detailInfo.title)"
    timeLabel.text = "Time: \(detailInfo.time)"
    descriptionLabel.text = "Description: \n \t\(detailInfo.transactionData.description)"
  }

  private func setupAutoLayout() {
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.snp.top).offset(navigationMaxY)
      $0.right.equalTo(view.snp.right).offset(-10)
      $0.left.equalTo(view.snp.left).offset(10)
      $0.height.equalTo(30)
    }

    timeLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(5)
      $0.left.equalTo(titleLabel.snp.left)
      $0.right.equalTo(titleLabel.snp.right)
      $0.height.equalTo(titleLabel.snp.height)
    }

    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(timeLabel.snp.bottom).offset(5)
      $0.left.equalTo(titleLabel.snp.left)
      $0.right.equalTo(titleLabel.snp.right)
      $0.height.greaterThanOrEqualTo(timeLabel.snp.height)
      $0.height.lessThanOrEqualTo(150)
    }

    detailTableView.snp.makeConstraints {
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(5)
      $0.left.equalTo(titleLabel.snp.left)
      $0.right.equalTo(titleLabel.snp.right)
      $0.bottom.equalToSuperview()
    }
  }
}

  // MARK: - UITableViewDelegate

extension TransactionDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44
  }
}

  // MARK: - UITableViewDataSource

extension TransactionDetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return detailInfo.cells.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: TransactionDetailTableViewCell.self, indexPath: indexPath)
    cell.cellModel = detailInfo.cells[indexPath.row]
    return cell
  }
}
