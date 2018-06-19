//
//  SFDispatchAfter.swift
//  SFDispatchAfter
//
//  Created by Viktor Gubriienko on 3/26/15.
//  Copyright (c) 2015 Viktor Gubriienko. All rights reserved.
//

import Foundation


@objcMembers public class SFDispatch: NSObject {
    
    fileprivate var executionBlock: (() -> Void)?
    fileprivate var timer: Timer?
    
    @discardableResult public class func dispatch(after delay: TimeInterval, executionBlock: @escaping () -> Void) -> SFDispatch {
        if Thread.isMainThread {
            return SFDispatchQueue.addDispatch(after: delay, executionBlock: executionBlock)
        } else {
            var dispatch: SFDispatch!
            
            print("Warning: dispatch will be done on the main thread")
            
            DispatchQueue.main.sync {
                dispatch = SFDispatchQueue.addDispatch(after: delay, executionBlock: executionBlock)
            }
            
            return dispatch
        }
    }
    
    public func fire() {
        if Thread.isMainThread {
            self.timer?.fire()
        } else {
            DispatchQueue.main.sync {
                self.timer?.fire()
            }
        }
    }
    
    public func cancel() {
        if Thread.isMainThread {
            SFDispatchQueue.cancelDispatch(self)
        } else {
            DispatchQueue.main.sync {
                SFDispatchQueue.cancelDispatch(self)
            }
        }
    }
    
    fileprivate func invalidate() {
        timer?.invalidate()
        timer = nil
        executionBlock = nil
    }
    
}


private class SFDispatchQueue {
    
    static var dispatches = [SFDispatch]()
    
    class func addDispatch(after delay: TimeInterval, executionBlock: @escaping () -> Void) -> SFDispatch {
        let dispatch = SFDispatch()

        let timer = Timer.scheduledTimer(timeInterval: delay,
            target: self,
            selector: #selector(execute(timer:)),
            userInfo: dispatch,
            repeats: false)
        
        dispatch.executionBlock = executionBlock
        dispatch.timer = timer
        
        dispatches.append(dispatch)
        
        return dispatch
    }
    
    class func cancelDispatch(_ dispatch: SFDispatch) {
        dispatch.invalidate()
        
        if let index = dispatches.index(of: dispatch) {
            dispatches.remove(at: index)
        }
    }
    
    // MARK: - Timer execution
    
    @objc private class func execute(timer: Timer) {
        let dispatch = timer.userInfo as! SFDispatch
        dispatch.executionBlock?()
        cancelDispatch(dispatch)
    }
    
}
