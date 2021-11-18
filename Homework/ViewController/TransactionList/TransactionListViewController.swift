//
//  TransactionListViewController.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/6.
//

import UIKit
import SnapKit

class TransactionListViewController: UIViewController {

  private var viewObject: TransactionListViewObject?
  private let viewModel: TransactionListViewModel

  private lazy var tableView: UITableView = {
    let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.reguster(with: [TransactionListDetailTableViewCell.self, TransactionListTotalCell.self])
    return tableView
  }()

  public init(viewModel: TransactionListViewModel = .init()) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    initView()
  }

  private func initView() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
}

  // MARK: - UITableViewDelegate

extension TransactionListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
      case 0:  return 0
      default: return 44
    }
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //    #warning("DOTO: TransactionListSectionView")
    guard section > 0, let model = viewObject?.sections[section - 1] else { return nil }
    let view = TransactionListSectionView(frame: .init(origin: .zero, size: .init(width: tableView.frame.width, height: 44)), transactionListItemViewObject: model)
    return view
  }
}

  // MARK: - UITableViewDelegate

extension TransactionListViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    if let sectionStatus = viewObject?.sections.isEmpty, sectionStatus {
      return 0
    } else {
      let sectionCount = self.viewObject?.sections.count ?? 0
      return sectionCount + 1
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
      case 0: return 1
      default:
        let cellCount = self.viewObject?.sections[section - 1].cells.count ?? 0
        return cellCount
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // #warning("DOTO: TransactionListDetailTableViewCell")
    switch indexPath.section {
      case 0:
        let cell = tableView.dequeueReusableCell(with: TransactionListTotalCell.self, indexPath: indexPath)
        cell.total = viewObject?.sum
        return cell
      default:
        let cell = tableView.dequeueReusableCell(with: TransactionListDetailTableViewCell.self, indexPath: indexPath)
        if let object = viewObject?.sections[indexPath.section - 1].cells[indexPath.row] {
          cell.updateView(object)
        }
        return .init()
    }
  }
}
