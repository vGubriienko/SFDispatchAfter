//
//  AppDelegate.swift
//  SFDispatchAfter
//
//  Created by Viktor Gubriienko on 3/26/15.
//  Copyright (c) 2015 Viktor Gubriienko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        let obj1 = SFDispatch.dispatch(after: 3.0) {
            NSLog("Should never be called")
        }
        
        SFDispatch.dispatch(after: 2.0) {
            obj1.cancel()
            NSLog("Second dispatch. Cancelling first dispatch here.")
        }
        
        let obj3 = SFDispatch.dispatch(after: 10.0) {
            NSLog("Third dispatch. Will trigger immediately")
        }
        
        obj3.fire()
        
        return true
    }

}

