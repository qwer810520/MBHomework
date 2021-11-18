//
//  TransactionListViewObjectTests.swift
//  HomeworkTests
//
//  Created by Min on 2021/11/18.
//

import XCTest
@testable import Homework

class TransactionListViewObjectTests: XCTestCase {

  func testUserTransactionToMappingViewObject() {
    let testDatas = makeTransactions()

    let sut = TransactionListViewObject(dataList: testDatas)

    XCTAssertEqual(sut.sum, 123)
    XCTAssertEqual(sut.sections.count, 2)
  }

  func testUserTransactionToMappingSectionViewObject() {
    let testDatas = makeTransactions()

    let sut = testDatas.map { TransactionListSectionViewObject(transaction: $0) }

    XCTAssertEqual(sut.count, testDatas.count)
    XCTAssertEqual(sut[0].title, testDatas[0].title)
    XCTAssertEqual(sut[0].time, "110/10/27")
    XCTAssertEqual(sut[0].cells.count, testDatas[0].details?.count)
    XCTAssertEqual(sut[1].title, testDatas[1].title)
    XCTAssertEqual(sut[1].time, "110/10/26")
    XCTAssertEqual(sut[1].cells.count, 0)
  }

  func testUseNotEmptyDetailsToMappingCellViewObjectListThanCheckNotNil() {
    let testDatas = makeTransactionDetail()

    let sut = testDatas?.map { TransactionListCellViewObject(detail: $0) }

    XCTAssertNotNil(sut)
    XCTAssertEqual(sut?[0].name, testDatas?[0].name)
    XCTAssertEqual(sut?[0].priceWithQuantity, "$12,000 x 4")
  }

  func testUseEmptyDetailsToMappingCellViewObjectListThanCheckIsNil() {
    let testDatas = makeEmptyTransactionDetail()

    let sut = testDatas?.map { TransactionListCellViewObject(detail: $0) }

    XCTAssertNil(sut)
  }

  // MARK: - Private Methods

  private func makeTransactions() -> [Transaction] {
    return [Transaction(id: 317, time: 1635334766, title: "Test", description: "Lorem Ipsum, Lipsum, Lorem, Ipsum, Text, Generate, Generator, Facts, Information, What, Why, Where, Dummy Text, Typesetting, Printing, de Finibus, Bonorum et Malorum, de Finibus Bonorum et Malorum, Extremes of Good and Evil, Cicero, Latin, Garbled, Scrambled, Lorem ipsum dolor sit amet, dolor, sit amet, consectetur, adipiscing, elit, sed, eiusmod, tempor, incididunt", details: [TransactionDetail(name: "TEST", quantity: 1, price: 123)]),
            Transaction(id: 318, time: 1635248697, title: "Gaming", description: "I wanna play game", details: nil)]
  }

  private func makeTransactionDetail() -> [TransactionDetail]? {
    return [TransactionDetail(name: "TEST", quantity: 4, price: 12000)]
  }

  private func makeEmptyTransactionDetail() -> [TransactionDetail]? {
    return nil
  }
}
