//
//  SFDispatchAfter.swift
//  SFDispatchAfter
//
//  Created by Viktor Gubriienko on 3/26/15.
//  Copyright (c) 2015 Viktor Gubriienko. All rights reserved.
//

import Foundation

public class SFDispatchObject: NSObject {
    
    private var executionBlock: (() -> Void)?
    private var timer: NSTimer?
    
    private func invalidate() {
        timer?.invalidate()
        timer = nil
        executionBlock = nil
    }
    
    public class func dispatchAfter(time: NSTimeInterval, executionBlock: () -> Void) -> SFDispatchObject {
        if NSThread.isMainThread() {
            return SFDispatchQueue.addDispatchObject(time, executionBlock: executionBlock)
        } else {
            var dispatchObject: SFDispatchObject!
            
            println("Warning: dispatch will be done on the main thread")
            
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                dispatchObject = SFDispatchQueue.addDispatchObject(time, executionBlock: executionBlock)
            })
            
            return dispatchObject
        }
    }
    
    public func fire() {
        if NSThread.isMainThread() {
            self.timer?.fire()
        } else {
            dispatch_sync(dispatch_get_main_queue()) {
                self.timer?.fire()
            }
        }
    }
    
    public func cancel() {
        if NSThread.isMainThread() {
            SFDispatchQueue.cancelDispatchObject(self)
        } else {
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                SFDispatchQueue.cancelDispatchObject(self)
            })
        }
    }
    
}

@objc (SFDispatchQueue)
private class SFDispatchQueue: NSObject {
    
    static var dispatches = [SFDispatchObject]()
    
    class func addDispatchObject(afterTime: NSTimeInterval, executionBlock: () -> Void) -> SFDispatchObject {
        let dispatchObject = SFDispatchObject()
        let timer = NSTimer.scheduledTimerWithTimeInterval(afterTime,
            target: self,
            selector: "execute:",
            userInfo: dispatchObject,
            repeats: false)
        
        dispatchObject.executionBlock = executionBlock
        dispatchObject.timer = timer
        
        dispatches.append(dispatchObject)

        return dispatchObject
    }
    
    class func cancelDispatchObject(dispatchObject: SFDispatchObject) {
        dispatchObject.invalidate()
        
        if let index = find(dispatches, dispatchObject) {
            dispatches.removeAtIndex(index)
        }
    }
    
    // MARK: - Timer execution
    @objc private class func execute(timer: NSTimer) {
        let dispatchObject = timer.userInfo as! SFDispatchObject
        dispatchObject.executionBlock?()
        cancelDispatchObject(dispatchObject)
    }
    
}