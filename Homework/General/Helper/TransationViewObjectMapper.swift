//
//  TransationViewObjectMapper.swift
//  Homework
//
//  Created by Min on 2021/11/18.
//

import Foundation

class TransationViewObjectMapper {
  static func viewObject(with list: [Transaction]) -> TransactionListViewObject {
    var transactionslist = list
    transactionslist.sort { $0.time > $1.time }
    return TransactionListViewObject(dataList: transactionslist)
  }
}
