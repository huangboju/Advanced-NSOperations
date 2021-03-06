/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
The file shows how to make an OperationCondition that composes another OperationCondition.
*/

import Foundation

/**
    A simple condition that negates the evaluation of another condition.
    This is useful (for example) if you want to only execute an operation if the 
    network is NOT reachable.
*/
public struct NegatedCondition<T: OperationCondition>: OperationCondition {
    public struct Error: ConditionError {
        public typealias Condition = NegatedCondition<T>

        public let negatedCondition: T
    }

    public static var name: String { 
        return "Not<\(T.name)>"
    }

    public static var isMutuallyExclusive: Bool {
        return T.isMutuallyExclusive
    }

    let condition: T

    public init(condition: T) {
        self.condition = condition
    }

    public func dependency(for operation: Operation) -> Foundation.Operation? {
        return condition.dependency(for: operation)
    }

    public func evaluate(for operation: Operation, completion: @escaping (OperationConditionResult) -> Void) {
        condition.evaluate(for: operation) { result in
            switch result {
            case .failed(_):
                // If the composed condition failed, then this one succeeded.
                completion(.satisfied)
            case .satisfied:
                // If the composed condition succeeded, then this one failed.
                completion(.failed(Error(negatedCondition: self.condition)))
            }
        }
    }
}
