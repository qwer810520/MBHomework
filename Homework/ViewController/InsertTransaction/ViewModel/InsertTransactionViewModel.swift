//
//  InsertTransactionViewModel.swift
//  Homework
//
//  Created by Min on 2021/11/19.
//

import Foundation
import RxSwift
import RxCocoa

class InsertTransactionViewModel {

  @Inject private var apiManager: APIManager

  private let disposeBag = DisposeBag()
  private var requestParameters = InsertTransactionModel(title: "", time: 0, description: "", details: [])

  enum InsertRequestError: LocalizedError {
    case parametersIsEmpty, requestFail
  }

  private func postNewTransactionObject(with info: InsertTransactionModel) -> Single<TransactionListViewObject> {
    return apiManager.postNewTransactionsInfo(with: info)
      .map { (transactions) -> TransactionListViewObject in
        return TransationViewObjectMapper.viewObject(with: transactions)
      }
      .observe(on: MainScheduler.instance)
  }
}

  // MARK: - ViewModelType

extension InsertTransactionViewModel: ViewModelType {
  struct Input {
    let title: Observable<String>
    let time: Observable<Int>
    let description: Observable<String>
    let details: Observable<[InsertTransactionDetailModel]>
    let insertTrigger: PublishRelay<Void>
  }

  struct Output {
    let responseResult: BehaviorRelay<TransactionListViewObject>
  }

  func transform(input: Input) -> Output {
    let response = BehaviorRelay<TransactionListViewObject>(value: TransactionListViewObject(dataList: []))

    Observable.combineLatest(input.title.asObservable(), input.time.asObservable(), input.description.asObservable())
      .map { return InsertTransactionModel(title: $0, time: $1, description: $2, details: []) }
      .subscribe(onNext: {
        self.requestParameters = $0
      }).disposed(by: disposeBag)

    input.details
      .subscribe(onNext: {
        self.requestParameters.details = $0
      }).disposed(by: disposeBag)

    input.insertTrigger.flatMapLatest { _ -> Observable<TransactionListViewObject> in
      return self.postNewTransactionObject(with: self.requestParameters)
        .asObservable()
    }.subscribe(onNext: {
      response.accept($0)
    }).disposed(by: disposeBag)

    return Output(responseResult: response)
  }
}

