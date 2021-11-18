//
//  InsertTransactionDetailCell.swift
//  Homework
//
//  Created by Min on 2021/11/19.
//

import UIKit
import SnapKit

protocol InsertDetailCellDelegate: class {
  func nameInputValueChange(with cell: UICollectionViewCell, text: String)
  func quantityInputValueChange(with cell: UICollectionViewCell, quantity: Int)
  func priceInputValueChange(with cell: UICollectionViewCell, price: Int)
  func textFieldBeginEdit(wit cell: UICollectionViewCell)
}

class InsertTransactionDetailCell: UICollectionViewCell {

  lazy private(set) var nameInputTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.placeholder = "Name"
    textField.delegate = self
    textField.addTarget(self, action: #selector(nameInputValueChange(with:)), for: .editingChanged)
    return textField
  }()

  lazy private(set) var quantityInputTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.keyboardType = .numberPad
    textField.placeholder = "Quantity"
    textField.delegate = self
    textField.addTarget(self, action: #selector(quantityInputValueChange(with:)), for: .editingChanged)
    return textField
  }()

  lazy private(set) var priceInputTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.keyboardType = .numberPad
    textField.placeholder = "Price"
    textField.delegate = self
    textField.addTarget(self, action: #selector(priceInputValueChange(with:)), for: .editingChanged)
    return textField
  }()

  // MARK: - Initialization

  weak var delegate: InsertDetailCellDelegate?

  var dataInfo: InsertTransactionDetailModel? {
    didSet {
      guard let dataInfo = dataInfo else { return }
      nameInputTextField.text = dataInfo.name
      quantityInputTextField.text = dataInfo.quantity > 0 ? "\(dataInfo.quantity)" : ""
      priceInputTextField.text = dataInfo.price > 0 ? "\(dataInfo.price)" : ""
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUserInterface()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private Methods

  private func setupUserInterface() {
    contentView.addSubviews([nameInputTextField, quantityInputTextField, priceInputTextField])
    setupAutoLayout()
  }

  private func setupAutoLayout() {
    nameInputTextField.snp.makeConstraints {
      $0.left.equalToSuperview().offset(10)
      $0.top.equalToSuperview().offset(5)
      $0.right.equalToSuperview().offset(-10)
      $0.height.equalTo(40)
    }

    quantityInputTextField.snp.makeConstraints {
      $0.left.equalTo(nameInputTextField.snp.left)
      $0.right.equalTo(nameInputTextField.snp.right)
      $0.top.equalTo(nameInputTextField.snp.bottom).offset(5)
      $0.height.equalTo(nameInputTextField.snp.height)
    }

    priceInputTextField.snp.makeConstraints {
      $0.left.equalTo(nameInputTextField.snp.left)
      $0.right.equalTo(nameInputTextField.snp.right)
      $0.top.equalTo(quantityInputTextField.snp.bottom).offset(5)
      $0.height.equalTo(nameInputTextField.snp.height)
    }
  }

  // MARK: - Action Methods

  @objc private func nameInputValueChange(with textField: UITextField) {
    delegate?.nameInputValueChange(with: self, text: textField.text ?? "")
  }

  @objc private func quantityInputValueChange(with textField: UITextField) {
    guard let text = textField.text, let number = Int(text) else { return }
    delegate?.quantityInputValueChange(with: self, quantity: number)
  }

  @objc private func priceInputValueChange(with textField: UITextField) {
    guard let text = textField.text, let number = Int(text) else { return }
    delegate?.priceInputValueChange(with: self, price: number)
  }
}

  // MARK: - UITextViewDelegate

extension InsertTransactionDetailCell: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    delegate?.textFieldBeginEdit(wit: self)
  }
}
