//
//  InsertTransactionModel.swift
//  Homework
//
//  Created by Min on 2021/11/19.
//

import Foundation

struct InsertTransactionModel {
  var title: String
  var time: Int
  var description: String
  var details: [InsertTransactionDetailModel]

  var isEmpty: Bool {
    return title.isEmpty || time == 0 || description.isEmpty
  }

  init(title: String, time: Int, description: String, details: [InsertTransactionDetailModel]) {
    self.title = title
    self.time = time
    self.description = description
    self.details = details
  }
}

  // MARK: - HTTPParametersType

extension InsertTransactionModel: HTTPParametersType {
  var jsonParameters: [String : Any]? {
    [
      "title": title,
      "time": time,
      "description": description,
      "details": details.map { $0.jsonParameters }
    ]
  }
}
