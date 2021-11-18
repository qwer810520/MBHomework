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
}

struct TransactionDetail: Codable {
    let name: String
    let quantity: Int
    let price: Int
}
