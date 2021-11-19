//
//  LocalTransactionsDetailModel.swift
//  Homework
//
//  Created by Min on 2021/11/19.
//

import Foundation

struct LocalTransactionsDetailModel {
  var transactionID: Int
  var detail: TransactionDetail

  init() {
    self.transactionID = 0
    self.detail = TransactionDetail(name: "", quantity: 0, price: 0)
  }
}
