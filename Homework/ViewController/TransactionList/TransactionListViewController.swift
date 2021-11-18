//
//  TransactionListViewController.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/6.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class TransactionListViewController: UIViewController {

  private let disposeBag = DisposeBag()

  private var viewObject: TransactionListViewObject? = nil {
    didSet {
      DispatchQueue.main.async { [weak self] in
        self?.tableView.reloadData()
      }
    }
  }
  private let viewModel: TransactionListViewModel
  private let refreshTrigger = PublishSubject<Void>()
  private let deleteTransactionTrigger = PublishSubject<Int>()

  private lazy var tableView: UITableView = {
    let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.reguster(with: [TransactionListDetailTableViewCell.self, TransactionListTotalCell.self])
    tableView.refreshControl = refreshControl
    return tableView
  }()

  private lazy var refreshControl: UIRefreshControl = {
    return UIRefreshControl()
  }()

  private lazy var insertNavitionItem: UIBarButtonItem = {
    let item = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    return item
  }()

  public init(viewModel: TransactionListViewModel = .init()) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  // MARK: - Initialization

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUserInterface()
    bindViewModel()
    refreshTrigger.onNext(())
  }

  // MARK: - Private Methods

  private func setupUserInterface() {
    navigationItem.title = "Main"
    navigationItem.rightBarButtonItem = insertNavitionItem
    view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }

  private func bindViewModel() {
    let input = TransactionListViewModel.Input(fetchContentTrigger: refreshTrigger, deleteTransactionTrigger: deleteTransactionTrigger)
    let output = viewModel.transform(input: input)

    output.viewObject
      .subscribe(onNext: { [weak self] result in
        self?.viewObject = result
      })
      .disposed(by: disposeBag)

    output.isLoading
      .subscribe(onNext: { [weak self] status in
        DispatchQueue.main.async {
          guard let self = self, let refreshControl = self.tableView.refreshControl else { return }
          switch status {
            case false where refreshControl.isRefreshing:
              self.tableView.refreshControl?.endRefreshing()
            default: break
          }
        }
      })
      .disposed(by: disposeBag)

    refreshControl.rx.controlEvent(.valueChanged)
      .bind(to: refreshTrigger)
      .disposed(by: disposeBag)

    tableView.rx.itemSelected
      .asObservable()
      .subscribe(onNext: { [weak self] indexPath in
        self?.tableView.deselectRow(at: indexPath, animated: true)
        self?.tableView.reloadRows(at: [indexPath], with: .automatic)

        guard indexPath.section > 0, let detailInfo = self?.viewObject?.sections[indexPath.section - 1] else { return }

        let detailController = TransactionDetailViewController(transactionInfo: detailInfo)
        self?.navigationController?.pushViewController(detailController, animated: true)
      })
      .disposed(by: disposeBag)

    insertNavitionItem.rx.tap
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        let insertController = InsertTransactionViewController()
        insertController.newViewObject.subscribe(onNext: { viewObject in
          self.viewObject = nil
          self.viewModel.localViewObject.accept(viewObject)
        }).disposed(by: self.disposeBag)
        self.navigationController?.pushViewController(insertController, animated: true)
      })
      .disposed(by: disposeBag)
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
    let view = TransactionListSectionView(frame: .init(origin: .zero, size: .init(width: tableView.frame.width, height: 44)), transactionListItemViewObject: model, delegate: self)
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

  // MARK: - TransactionListFooterDelegate

extension TransactionListViewController: TransactionListSectionDelegate {
  func deleteButtonDidPressed(with id: Int) {
    deleteTransactionTrigger.onNext(id)
  }
}
