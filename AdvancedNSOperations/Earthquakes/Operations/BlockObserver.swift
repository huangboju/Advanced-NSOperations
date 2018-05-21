/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This file shows how to implement the OperationObserver protocol.
*/

import Foundation

/**
    The `BlockObserver` is a way to attach arbitrary blocks to significant events
    in an `Operation`'s lifecycle.
*/
struct BlockObserver: OperationObserver {
    // MARK: Properties
    
    fileprivate let startHandler: ((CustomOperation) -> Void)?
    fileprivate let produceHandler: ((CustomOperation, Operation) -> Void)?
    fileprivate let finishHandler: ((CustomOperation, [NSError]) -> Void)?
    
    init(startHandler: ((CustomOperation) -> Void)? = nil, produceHandler: ((CustomOperation, Operation) -> Void)? = nil, finishHandler: ((CustomOperation, [NSError]) -> Void)? = nil) {
        self.startHandler = startHandler
        self.produceHandler = produceHandler
        self.finishHandler = finishHandler
    }
    
    // MARK: OperationObserver
    
    func operationDidStart(_ operation: CustomOperation) {
        startHandler?(operation)
    }
    
    func operation(_ operation: CustomOperation, didProduceOperation newOperation: Operation) {
        produceHandler?(operation, newOperation)
    }
    
    func operationDidFinish(_ operation: CustomOperation, errors: [NSError]) {
        finishHandler?(operation, errors)
    }
}
