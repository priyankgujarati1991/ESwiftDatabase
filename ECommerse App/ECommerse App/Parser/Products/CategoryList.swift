//
//  CategoryList.swift
//  ECommerse App
//
//  Created by Saurabh Prajapati on 20/02/18.
//  Copyright © 2018 Saurabh Prajapati. All rights reserved.
//

import UIKit
import SQLite3

class CategoryList: NSObject {
    var id:Int32 = 0
    var name:String = ""
    var products = [ProductList]()
    var childCategories = [Int32]()
    
    class func insert(_ categories:[CategoryList]){
        sqlite3_exec(AppDelegate.dbHelper.database!, "BEGIN", nil, nil, nil)
        let query = "insert into \(DBHelper.DatabaseTable.Category)(categoryId, categoryName, childCategories) values(?,?,?);"
        
        var statement:OpaquePointer?
        
        if sqlite3_prepare(AppDelegate.dbHelper.database!, query, -1, &statement, nil) == SQLITE_OK{
            for category in categories{
                var i:Int32 = 1
                
                sqlite3_bind_int(statement, i, category.id)
                i  += 1
                
                sqlite3_bind_text(statement, i, category.name, -1, SQLITE_TRANSIENT)
                i += 1
                
                var childCats = ""
                for (index,value) in category.childCategories.enumerated(){
                    if index == 0{
                        childCats = "\(value)"
                    }else{
                        childCats += ",\(value)"
                    }
                }
                
                sqlite3_bind_text(statement, i, childCats, -1, SQLITE_TRANSIENT)
                
                if sqlite3_step(statement) == SQLITE_DONE{
                    print("category inserted successfully")
                    sqlite3_reset(statement)
                }
            }
        }
        sqlite3_finalize(statement)
    }
    
    class func getAllRecords() -> [CategoryList]{
        let query = "select categoryId, categoryName, childCategories from \(DBHelper.DatabaseTable.Category)"
        var statement:OpaquePointer?
        
        var arrCategories = [CategoryList]()
        if sqlite3_prepare(AppDelegate.dbHelper.database!, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW{
                
                let categoryList = CategoryList()
                var i:Int32 = 0
                
                categoryList.id = sqlite3_column_int(statement, i)
                i += 1
                
                if let name = sqlite3_column_text(statement, i){
                    categoryList.name = String(cString:name)
                }
                i += 1
                
                var arrChildCategories = [Int32]()
                if let childCats = sqlite3_column_text(statement, i){
                    let tempCats = String(cString:childCats).components(separatedBy: ",")
                    
                    for cat in tempCats{
                        if let intValue = Int32(cat){
                            arrChildCategories.append(intValue)
                        }
                    }
                }
                categoryList.childCategories = arrChildCategories
                i += 1
                
                arrCategories.append(categoryList)
            }
        }
        return arrCategories
    }
    
    class func getRecord(by id:Int32) -> CategoryList?{
        let query = "select categoryId, categoryName, childCategories from \(DBHelper.DatabaseTable.Category)"
        var statement:OpaquePointer?
        
        var categoryList = CategoryList()
        
        if sqlite3_prepare(AppDelegate.dbHelper.database!, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW{
                
                categoryList = CategoryList()
                var i:Int32 = 0
                
                categoryList.id = sqlite3_column_int(statement, i)
                i += 1
                
                if let name = sqlite3_column_text(statement, i){
                    categoryList.name = String(cString:name)
                }
                i += 1
                
                var arrChildCategories = [Int32]()
                if let childCats = sqlite3_column_text(statement, i){
                    let tempCats = String(cString:childCats).components(separatedBy: ",")
                    
                    for cat in tempCats{
                        if let intValue = Int32(cat){
                            arrChildCategories.append(intValue)
                        }
                    }
                }
                categoryList.childCategories = arrChildCategories
                i += 1
            }
        }
        return categoryList
    }
    
    class func delete(by id:Int32){
        let query = "delete from \(DBHelper.DatabaseTable.Category) where id = '\(id)'"
        var statement:OpaquePointer?
        
        if sqlite3_prepare(AppDelegate.dbHelper.database!, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE{
                print("Category deleted")
            }
        }
        sqlite3_finalize(statement)
    }
    
    class func deleteAllRecords(){
        let query = "delete from \(DBHelper.DatabaseTable.Category)"
        var statement:OpaquePointer?
        
        if sqlite3_prepare(AppDelegate.dbHelper.database!, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE{
                print("All Categories deleted successfully")
            }
        }
        sqlite3_finalize(statement)
    }

}
