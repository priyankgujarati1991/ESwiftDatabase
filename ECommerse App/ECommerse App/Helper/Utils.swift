//
//  Utils.swift
//  ECommerse App
//
//  Created by Saurabh Prajapati on 20/02/18.
//  Copyright © 2018 Saurabh Prajapati. All rights reserved.
//

import UIKit

class Utils: NSObject {
    static let shared = Utils()
    
    override init() {
        super.init()
        setAPIURL()
    }
    
    enum URLPreferences:String {
        case Products = "Products"
    }
    
    enum Preferences:String {
        case Dummy = "Dummy"
    }
    
    func setAPIURL(){
        let prefs = UserDefaults.standard
        
        let productURL = "https://stark-spire-93433.herokuapp.com/json"
        prefs.set(productURL, forKey: URLPreferences.Products.rawValue)
        
        //add other url below
        prefs.synchronize()
    }
    
    func getAPIURL(for urlPrefs:URLPreferences) -> URL? {
        var url:URL?
        if let strURL = UserDefaults.standard.object(forKey: urlPrefs.rawValue) as? String{
            url = URL(string: strURL)
        }
        return url
    }
}
