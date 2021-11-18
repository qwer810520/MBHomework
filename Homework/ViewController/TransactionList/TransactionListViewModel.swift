//
//  TransactionListViewModel.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/6.
//

import Foundation
import RxSwift

class TransactionListViewModel {

    var disposeBag:DisposeBag = .init()

    @Inject private var apiManager: APIManager
    @Inject private var dbManager: DBManager

    func getTransactionListViewObjects() -> Single<TransactionListViewObject> {
        return apiManager.getTransactions().map { (transactions) -> TransactionListViewObject in
            #warning("DOTO: make TransactionListViewObject then sort sections by time")
            return .init(sum: 0, sections: [])
        }.observe(on: MainScheduler.instance)
    }

}
