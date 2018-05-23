//
//  ReachabilityManager.swift
//  ECommerse App
//
//  Created by Saurabh Prajapati on 21/02/18.
//  Copyright © 2018 Saurabh Prajapati. All rights reserved.
//

import UIKit

class ReachabilityManager: NSObject {
    //declare this property where it won't go out of scope relative to your listener
    let reachability = Reachability()!
    
    override init() {
        super.init()
        registerNotifier()
    }
    
    func registerNotifier(){
        self.reachability.whenReachable = { reachability in
            AppDelegate.shared.isInternetReachable = true
            
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        
        self.reachability.whenUnreachable = { _ in
            print("Not reachable")
            AppDelegate.shared.isInternetReachable = false
        }
        
        do {
            try self.reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
