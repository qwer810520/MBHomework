//
//  APIManager.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/6.
//

import Foundation
import Alamofire
import RxSwift

class APIManager {

  private static let host:String = "https://e-app-testing-z.herokuapp.com"
  private static let transaction:String = "/transaction"

  static let sharedInstance:APIManager = .init()

  func getTransactions() -> Single<[Transaction]> {
    return get().flatMap { (data) -> Single<[Transaction]> in
      return APIManager.handleDecode([Transaction].self, from: data)
    }
  }

  func postNewTransactionsInfo<T: HTTPParametersType>(with info: T) -> Single<[Transaction]> {
    return post(with: info).flatMap { data -> Single<[Transaction]> in
      return APIManager.handleDecode([Transaction].self, from: data)
    }
  }

  func deleteTransactions(with id: Int) -> Single<[Transaction]> {
    return delete(with: id).flatMap { data -> Single<[Transaction]> in
      return APIManager.handleDecode([Transaction].self, from: data)
    }
  }

  public enum DecodeError: Error, LocalizedError {
    case dataNull
    public var errorDescription: String? {
      switch self {
        case .dataNull:
          return "Data Null"
      }
    }
  }

  private static func handleDecode<T>(_ type: T.Type, from data: Data?) -> Single<T> where T: Decodable {
    if let strongData = data {
      do {
        let toResponse = try JSONDecoder().decode(T.self ,from: strongData)
        return Single<T>.just(toResponse)
      } catch {
        return Single.error(error)
      }
    } else {
      return Single.error(DecodeError.dataNull)
    }
  }

  private func get() -> Single<Data?> {
    return Single<Data?>.create { (singleEvent) -> Disposable in
      Alamofire.Session.default.request(APIManager.host + APIManager.transaction, method: .get).responseJSON { (response) in
        switch response.result {
          case .success:
            if let jsonData = response.data , let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
              print("JSONString = " + JSONString)
            }
            singleEvent(.success(response.data))
          case .failure(let error):
            singleEvent(.failure(error))
        }
      }
      return Disposables.create()
    }
  }

  private func post<T: HTTPParametersType>(with info: T) -> Single<Data?> {
    return Single<Data?>.create { singleEvent -> Disposable in
      let url = APIManager.host + APIManager.transaction
      AF.request(url, method: .post, parameters: info.jsonParameters, encoding: JSONEncoding.default).responseJSON { (response) in
        switch response.result {
          case .success:
            if let jsonData = response.data , let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
              print("Post response JSONString = " + JSONString)
            }
            singleEvent(.success(response.data))
          case .failure(let error):
            singleEvent(.failure(error))
        }
      }
      return Disposables.create()
    }
  }

  private func delete(with id: Int) -> Single<Data?> {
    return Single<Data?>.create { singleEvent -> Disposable in
      let url = "\(APIManager.host)\(APIManager.transaction)/\(id)"
      AF.request(url, method: .delete).responseJSON { response in
        switch response.result {
          case .success:
            if let jsonData = response.data , let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
              print("Delegate response JSONString = " + JSONString)
            }
            singleEvent(.success(response.data))
          case .failure(let error):
            singleEvent(.failure(error))
        }

      }
      return Disposables.create()
    }
  }
}
