//
//  FormatHelper.swift
//  Homework
//
//  Created by Min on 2021/11/18.
//

import Foundation

final class FormatHelper {
  static func translateDateToString(with time: Double) -> String {
    let date = Date(timeIntervalSince1970: time)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyy/MM/dd"
    dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
    dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.republicOfChina)
    return dateFormatter.string(from: date)
  }

  static func translatePriceWithQuantity(withPrice price: Int, quantity: Int) -> String {
    let numberFormat = NumberFormatter()
    numberFormat.numberStyle = .currency
    numberFormat.maximumFractionDigits = 0
    let moneyFormat = numberFormat.string(from: NSNumber(value: price))
    return "\(moneyFormat ?? "") x \(quantity)"
  }
}
