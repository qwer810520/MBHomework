//
//  InsertTransactionDetailModel.swift
//  Homework
//
//  Created by Min on 2021/11/19.
//

import Foundation

struct InsertTransactionDetailModel: Encodable {
  var name: String
  var quantity: Int
  var price: Int

  var isEmpty: Bool {
    return name.isEmpty || quantity == 0 || price == 0
  }
}
