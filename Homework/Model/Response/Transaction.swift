//
//  Transaction.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/6.
//

import Foundation

struct Transaction: Codable {
  let id: Int
  let time: Int
  let title: String
  let description: String
  let details: [TransactionDetail]?

  var totlePrice: Int {
    return details?.reduce(0, { $0 + $1.totalPrice }) ?? 0
  }

  enum CodingKeys: String, CodingKey {
    case id, time, title, description, details
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decode(Int.self, forKey: .id)
    time = try values.decode(Int.self, forKey: .time)
    title = try values.decode(String.self, forKey: .title)
    description = try values.decode(String.self, forKey: .description)
    details = try? values.decode([TransactionDetail].self, forKey: .details)
  }

  init(id: Int, time: Int, title: String, description: String, details: [TransactionDetail]?) {
    self.id = id
    self.time = time
    self.title = title
    self.description = description
    self.details = details
  }
}

struct TransactionDetail: Codable {
  let name: String
  let quantity: Int
  let price: Int

  var totalPrice: Int {
    return price * quantity
  }

  init(name: String, quantity: Int, price: Int) {
    self.name = name
    self.quantity = quantity
    self.price = price
  }
}
