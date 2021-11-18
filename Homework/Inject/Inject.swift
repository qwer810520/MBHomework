//
//  Inject.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/6.
//

import Foundation

@propertyWrapper
public struct Inject<T> {

    public var wrappedValue: T {
        Resolver.shareInstance.resolve(T.self)
    }

    public init() {}
}
