//
//  UserDefaults.swift
//  ECommerse App
//
//  Created by Saurabh Prajapati on 20/02/18.
//  Copyright © 2018 Saurabh Prajapati. All rights reserved.
//

import UIKit

extension UserDefaults{
    func set(object:Any ,forKey key:Utils.Preferences){
        self.set(object, forKey: key.rawValue)
        synchronize()
    }
    
    func value(forKey key: Utils.URLPreferences) -> Any? {
        return value(forKey:key.rawValue)
    }
}
