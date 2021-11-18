//
//  ViewModelType.swift
//  Homework
//
//  Created by Min on 2021/11/18.
//

import Foundation

protocol ViewModelType {
  associatedtype Input
  associatedtype Output

  func transform(input: Input) -> Output
}
