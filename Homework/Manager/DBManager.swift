//
//  DBManager.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/7.
//

import Foundation
import FMDB
import RxSwift

#warning("DOTO: DBManager")

class DBManager {

  static let sharedInstance: DBManager = .init()

  private var database: FMDatabase?

  private var databasePath: String {
    let defaultPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    return defaultPath.stringByAppendingPathComponent(path: "HWDatabase.sqlite")
  }

  // MARK: - Private Methods

  func initDatabase() {
    if !FileManager.default.fileExists(atPath: databasePath) {
      let status = openDataBase()
      guard status else { return }
      tablesInit()
    } else {
      openDataBase()
    }
  }

  @discardableResult
  func dataBase() -> FMDatabase? {
    guard openDataBase() else { return nil }
    return database
  }

  @discardableResult
  func queue() -> FMDatabaseQueue? {
    return FMDatabaseQueue(path: databasePath)
  }

  @discardableResult
  private func openDataBase() -> Bool {
    database = FMDatabase(path: databasePath)
    guard let database = database else { return false }
    return database.open()
  }

  private func tablesInit() {
    var sql = """
        CREATE TABLE IF NOT EXISTS T_TransactionInfo(
        _id Integer Primary key autoincrement,
        transactionID Integer,
        time Integer,
        title Text,
        description Text)
    """

    createTable(with: sql)

    sql = """
        CREATE TABLE IF NOT EXISTS T_TransactionDetail(
        _id Integer Primary key autoincrement,
        transactionID Integer,
        name Text,
        quantity Integer,
        price Integer)
    """

    createTable(with: sql)
  }

  private func createTable(with spl: String) {
    do {
      try database?.executeUpdate(spl, values: nil)
    } catch {
      print("Create table failure, error is \(error.localizedDescription) spl is \(spl)")
    }
  }
}

private extension String {
  func stringByAppendingPathComponent(path: String) -> String {
    let nsString = self as NSString
    return nsString.appendingPathComponent(path)
  }
}
