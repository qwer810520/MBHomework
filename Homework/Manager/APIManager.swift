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

}
