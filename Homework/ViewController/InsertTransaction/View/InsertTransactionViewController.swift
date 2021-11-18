//
//  InsertTransactionViewController.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/7.
//

import UIKit

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class InsertTransactionViewController: UIViewController {

  #warning("DOTO: Insert Transaction")

  lazy private var collectionView: UICollectionView = {
    let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    view.delegate = self
    view.dataSource = self
    view.register(with: [InsertTransactionTitleOrTimeCell.self, InsertTransactionDetailCell.self])
    return view
  }()

  lazy private var addNewDetailButton: UIButton = {
    let button = UIButton()
    button.setTitleColor(.white, for: .normal)
    button.setTitle("Add records", for: .normal)
    button.backgroundColor = .black
    button.layer.cornerRadius = 4
    return button
  }()

  lazy private var insertBarItem: UIBarButtonItem = {
    let item = UIBarButtonItem.init(title: "Insert", style: .plain, target: nil, action: nil)
    return item
  }()
  
  private let disposeBag = DisposeBag()
  private var currentEditCell: UICollectionViewCell?
  private var localInsertDetails = [InsertTransactionDetailModel]() {
    didSet {
      insertDetails.accept(localInsertDetails)
    }
  }
  private var insertTitle = BehaviorRelay<String>(value: "")
  private var insertTime = BehaviorRelay<Int>(value: 0)
  private var insertDescription = BehaviorRelay<String>(value: "")
  private var insertDetails = BehaviorRelay<[InsertTransactionDetailModel]>(value: [])

  // MARK: - UIViewController

  init() {
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
    navigationItem.title = "Insert"
    view.backgroundColor = .white
    navigationItem.rightBarButtonItem = insertBarItem
    setupAutoLayout()
    bindViewModel()
  }

  private func setupAutoLayout() {
    view.addSubviews([collectionView, addNewDetailButton])

    addNewDetailButton.snp.makeConstraints {
      $0.left.equalToSuperview().offset(5)
      $0.right.equalToSuperview().offset(-5)
      $0.bottom.equalToSuperview().offset(-10)
      $0.height.equalTo(50)
    }

    collectionView.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
      $0.bottom.equalTo(addNewDetailButton.snp.top).offset(-5)
    }
  }

  private func bindViewModel() {
    collectionView.rx.itemSelected
      .subscribe(onNext: { [weak self] _ in
        self?.view.endEditing(true)
      })
      .disposed(by: disposeBag)

    addNewDetailButton.rx.controlEvent(.touchUpInside)
      .subscribe(onNext: { [weak self] _ in
        guard let list = self?.localInsertDetails else { return }
        if list.isEmpty {
          self?.localInsertDetails.append(InsertTransactionDetailModel(name: "", quantity: 0, price: 0))
          self?.collectionView.reloadSections(IndexSet(integer: 1))
        } else if let lastInfo = list.last, !lastInfo.isEmpty {
          self?.localInsertDetails.append(InsertTransactionDetailModel(name: "", quantity: 0, price: 0))
          self?.collectionView.reloadSections(IndexSet(integer: 1))
        }
      }).disposed(by: disposeBag)

    NotificationCenter.default.rx
      .notification(UIResponder.keyboardWillShowNotification, object: nil)
      .subscribe(onNext: { [weak self] notification in
        if let height = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height, let cell = self?.currentEditCell, let collectionView = self?.collectionView, let navigationHeight = self?.navigationMaxY {
          let screenHeight = UIScreen.main.bounds.height
          guard (cell.frame.maxY - collectionView.contentOffset.y) > (screenHeight - height - navigationHeight) else { return }
          let space = (cell.frame.maxY - collectionView.contentOffset.y) - (screenHeight - height - navigationHeight)
          self?.collectionView.frame.origin.y = -space
        }

      })
      .disposed(by: disposeBag)

    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification, object: nil)
      .subscribe(onNext: { [weak self] _ in
        guard self?.collectionView.frame.origin.y != 0 else { return }
        self?.collectionView.frame.origin.y = 0
      })
      .disposed(by: disposeBag)
  }
}

  // MARK: - UICollectionViewDelegateFlowLayout

extension InsertTransactionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch indexPath.section {
      case 0 :
        return .init(width: collectionView.frame.width, height: 204)
      default:
        return .init(width: collectionView.frame.width, height: 140)
    }
  }
}

  // MARK: - UICollectionViewDataSource

extension InsertTransactionViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
      case 0:
        return 1
      default:
        return localInsertDetails.count
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch indexPath.section {
      case 0:
        let cell = collectionView.dequeueReusableCell(with: InsertTransactionTitleOrTimeCell.self, for: indexPath)
        cell.nameTextField.rx.value.orEmpty
          .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
          .distinctUntilChanged()
          .bind(to: insertTitle)
          .disposed(by: disposeBag)

        cell.toolBar.cancelButtonItem.rx.tap
          .subscribe(onNext: { [weak self] _ in
            self?.view.endEditing(true)
          })
          .disposed(by: disposeBag)

        cell.datePicker.rx.date
          .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
          .map { date -> Int in
            return Int(date.timeIntervalSince1970)
          }
          .bind(to: insertTime)
          .disposed(by: disposeBag)

        cell.descriptionInputView.rx.value.orEmpty
          .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
          .distinctUntilChanged()
          .bind(to: insertDescription)
          .disposed(by: disposeBag)
        return cell
      default:
        let cell = collectionView.dequeueReusableCell(with: InsertTransactionDetailCell.self, for: indexPath)
        cell.dataInfo = localInsertDetails[indexPath.item]
        cell.delegate = self
        return cell
    }
  }
}

  // MARK: - InsertDetailCellDelegate

extension InsertTransactionViewController: InsertDetailCellDelegate {
  func textFieldBeginEdit(wit cell: UICollectionViewCell) {
    currentEditCell = cell
  }

  func nameInputValueChange(with cell: UICollectionViewCell, text: String) {
    guard let indexPath = findIndexPath(with: cell) else { return }
    localInsertDetails[indexPath.item].name = text
  }

  func quantityInputValueChange(with cell: UICollectionViewCell, quantity: Int) {
    guard let indexPath = findIndexPath(with: cell) else { return }
    localInsertDetails[indexPath.item].quantity = quantity
  }

  func priceInputValueChange(with cell: UICollectionViewCell, price: Int) {
    guard let indexPath = findIndexPath(with: cell) else { return }
    localInsertDetails[indexPath.item].price = price
  }

  // MARK: - Private Methods

  private func findIndexPath(with cell: UICollectionViewCell) -> IndexPath? {
    return collectionView.indexPath(for: cell)
  }
}

