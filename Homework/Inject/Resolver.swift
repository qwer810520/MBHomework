//
//  Resolver.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/6.
//

import Foundation

class Resolver {

    static let shareInstance = Resolver()
    private var factories = [String: Any]()

    func setupFactories() {
        self.factories = [String: Any]()
        self.add(type: APIManager.self, APIManager.sharedInstance)
        self.add(type: DBManager.self, DBManager.sharedInstance)
    }

    func add<T>(type: T.Type, _ factory: T) {
        let key = String(describing: T.self)
        factories[key] = factory
    }

    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: T.self)
        guard let component: T = factories[key] as? T else {
            fatalError("Dependency '\(T.self)' not resolved!")
        }
        return component
    }
}
