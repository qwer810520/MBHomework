//
//  InsertTransactionTitleOrTimeCell.swift
//  Homework
//
//  Created by Min on 2021/11/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class InsertTransactionTitleOrTimeCell: UICollectionViewCell {

  lazy private var nameTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "Title:"
    return label
  }()

  lazy private(set) var nameTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    return textField
  }()

  lazy private var timeTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "Time: "
    return label
  }()

  lazy private(set) var timeTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    return textField
  }()

  lazy private(set) var datePicker: UIDatePicker = {
    let view = UIDatePicker()
    view.datePickerMode = .date
    view.date = Date()
    view.locale = Locale(identifier: "zh_Hant_TW")
    view.timeZone = TimeZone(identifier: "Asia/Taipei")
    view.calendar = Calendar(identifier: Calendar.Identifier.republicOfChina)
    view.preferredDatePickerStyle = .wheels
    return view
  }()

  lazy private(set) var toolBar: InsertTimeToolBar = {
    return InsertTimeToolBar()
  }()

  lazy private var descriptionTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "Description: "
    return label
  }()

  lazy private(set) var descriptionInputView: UITextView = {
    let textView = UITextView()
    textView.layer.borderColor = UIColor.lightGray.cgColor.copy(alpha: 0.3)
    textView.layer.borderWidth = 1
    return textView
  }()

  private let disposeBag = DisposeBag()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUserInterface()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private Methods

  private func setupUserInterface() {
    contentView.addSubviews([nameTitleLabel, nameTextField, timeTitleLabel, timeTextField, descriptionTitleLabel, descriptionInputView])
    setupAutoLayout()

    timeTextField.inputView = datePicker
    timeTextField.inputAccessoryView = toolBar
    bindTimeTextField()
  }

  private func setupAutoLayout() {
    nameTitleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(5)
      $0.left.equalToSuperview().offset(10)
      $0.height.equalTo(40)
      $0.width.equalTo(100)
    }

    nameTextField.snp.makeConstraints {
      $0.top.equalTo(nameTitleLabel.snp.top)
      $0.left.equalTo(nameTitleLabel.snp.right).offset(5)
      $0.height.equalTo(nameTitleLabel.snp.height)
      $0.right.equalToSuperview().offset(-10)
    }

    timeTitleLabel.snp.makeConstraints {
      $0.top.equalTo(nameTitleLabel.snp.bottom).offset(5)
      $0.left.equalTo(nameTitleLabel.snp.left)
      $0.height.equalTo(nameTitleLabel.snp.height)
      $0.width.equalTo(nameTitleLabel.snp.width)
    }

    timeTextField.snp.makeConstraints {
      $0.top.equalTo(timeTitleLabel.snp.top)
      $0.left.equalTo(nameTextField.snp.left)
      $0.height.equalTo(nameTextField.snp.height)
      $0.right.equalTo(nameTextField.snp.right)
    }

    descriptionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(timeTitleLabel.snp.bottom).offset(5)
      $0.left.equalTo(nameTitleLabel.snp.left)
      $0.height.equalTo(nameTitleLabel.snp.height)
      $0.width.equalTo(nameTitleLabel.snp.width)
    }

    descriptionInputView.snp.makeConstraints {
      $0.top.equalTo(descriptionTitleLabel.snp.top)
      $0.left.equalTo(nameTextField.snp.left)
      $0.bottom.equalTo(contentView.snp.bottom).offset(-5)
      $0.right.equalTo(nameTextField.snp.right)
    }
  }

  private func bindTimeTextField() {
    datePicker.rx.date
      .map({ date -> String in
        return FormatHelper.translateDateToString(with: date.timeIntervalSince1970)
      })
      .bind(to: timeTextField.rx.text)
      .disposed(by: disposeBag)
  }
}

