//
//  TransactionListViewObject.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/7.
//

import Foundation

struct TransactionListViewObject {
  let sum: Int
  var sections: [TransactionListSectionViewObject]

  init(dataList: [Transaction]) {
    self.sum = dataList.reduce(0, { $0 + $1.totlePrice })
    self.sections = dataList.map { TransactionListSectionViewObject(transaction: $0) }
  }
}

struct TransactionListSectionViewObject {
  let title: String
  let time: String; // #warning("DOTO: format -> 109/10/01")
  let cells: [TransactionListCellViewObject]

  let transactionData: Transaction

  init(transaction: Transaction) {
    self.title = transaction.title
    self.time = FormatHelper.translateDateToString(with: Double(transaction.time))
    self.cells = transaction.details?.map ({ TransactionListCellViewObject(detail: $0) }) ?? []
    self.transactionData = transaction
  }
}

struct TransactionListCellViewObject {
  let name: String
  let priceWithQuantity: String; //#warning("DOTO: format -> $19,000 x 2")

  let detailData: TransactionDetail

  init(detail: TransactionDetail) {
    self.name = detail.name
    self.detailData = detail
    self.priceWithQuantity = FormatHelper.translatePriceWithQuantity(withPrice: detail.price, quantity: detail.quantity)
  }
}
