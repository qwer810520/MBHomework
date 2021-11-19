//
//  TransactionListViewModel.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/6.
//

import Foundation
import RxSwift
import RxCocoa

class TransactionListViewModel {

  var disposeBag: DisposeBag = .init()

  @Inject private var apiManager: APIManager
  @Inject private var dbManager: DBManager

  var localViewObject = BehaviorRelay(value: TransactionListViewObject(dataList: []))

  // MARK: - Private Methods

  private func getTransactionListViewObjects() -> Single<TransactionListViewObject> {
    return apiManager.getTransactions().map { (transactions) -> TransactionListViewObject in
//      #warning("DOTO: make TransactionListViewObject then sort sections by time")
      return TransationViewObjectMapper.viewObject(with: transactions)
    }.observe(on: MainScheduler.instance)
  }

  private func deleteTransactionInfo(with id: Int) -> Single<TransactionListViewObject> {
    return apiManager.deleteTransactions(with: id)
      .map { return TransationViewObjectMapper.viewObject(with: $0) }
      .observe(on: MainScheduler.instance)
  }

  private func fetchLocalTransactionListViewObject() -> Single<TransactionListViewObject> {
    return dbManager.fetchTransactions()
      .map { (transactions) -> TransactionListViewObject in
        return TransationViewObjectMapper.viewObject(with: transactions)
      }
      .observe(on: MainScheduler.instance)
  }

  private func isNetworkConnect() -> Bool {
    let reachability = Reachability(hostName: "www.apple.com")
    return reachability?.currentReachabilityStatus().rawValue != 0
  }
}

// MARK: - ViewModelType

extension TransactionListViewModel: ViewModelType {
  struct Input {
    let fetchContentTrigger: PublishSubject<Void>
    let deleteTransactionTrigger: PublishSubject<Int>
  }

  struct Output {
    let viewObject: BehaviorRelay<TransactionListViewObject>
    let isLoading: BehaviorRelay<Bool>
  }

  func transform(input: Input) -> Output {
    let isLoading = BehaviorRelay<Bool>(value: false)

    input.fetchContentTrigger.flatMapLatest {  _ -> Observable<TransactionListViewObject> in
      switch self.isNetworkConnect() {
        case true:
          return self.getTransactionListViewObjects()
            .asObservable()
        case false:
          return self.fetchLocalTransactionListViewObject()
            .asObservable()
      }
    }
    .subscribe(onNext: { result in
      self.localViewObject.accept(result)
      DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
        isLoading.accept(false)
      }
    })
    .disposed(by: disposeBag)

    input.deleteTransactionTrigger.flatMapLatest { id -> Observable<TransactionListViewObject> in
      return self.deleteTransactionInfo(with: id).asObservable()
    }.subscribe(onNext: {
      self.localViewObject.accept($0)
    }).disposed(by: disposeBag)

    localViewObject
      .skip(1)
      .subscribe(onNext: { [weak self] viewObject in
        self?.dbManager.insertTransactions(with: viewObject.sections)
      })
      .disposed(by: disposeBag)

    return Output(viewObject: localViewObject, isLoading: isLoading)
  }
}
