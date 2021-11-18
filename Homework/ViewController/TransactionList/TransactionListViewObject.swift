//
//  TransactionListViewObject.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/7.
//

import Foundation

struct TransactionListViewObject {
    let sum: Int
    let sections: [TransactionListSectionViewObject]
}

struct TransactionListSectionViewObject {
    let title: String
    let time: String; #warning("DOTO: format -> 109/10/01")
    let cells: [TransactionListCellViewObject]
}

struct TransactionListCellViewObject {
    let name: String
    let priceWithQuantity: String; #warning("DOTO: format -> $19,000 x 2")
}
