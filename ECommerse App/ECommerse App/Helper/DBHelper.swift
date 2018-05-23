
//
//  DBHelper.swift
//  ECommerse App
//
//  Created by Saurabh Prajapati on 20/02/18.
//  Copyright © 2018 Saurabh Prajapati. All rights reserved.
//

import Foundation
import SQLite3

/*
 
 show categories
     -> categories contains products
         -> product contains variants & tax
 
 variants -> create table variants(id INTEGER , productId INTEGER , color TEXT , size INTEGER , price INTEGER)
 products -> create table products(id INTEGER , categoryId INTEGER , name TEXT , date_added TEXT , taxName TEXT , taxValue Float , viewCount INTEGER , orderCount INTEGER , shares INTEGER)
 category -> create table category(id INTEGER , name TEXT , childCategories TEXT(this should be comma separated array))
 
 */

public let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
public let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

class DBHelper: NSObject {
    
    var database:OpaquePointer?
    let databaseName = "ECommerse.db"

    enum DatabaseTable:String {
        case Products = "Products"
        case Category = "Category"
        case Variant = "Variant"
    }
    
    override init() {
        super.init()
        
        openDatabase()
        createProductsTable()
        createCategoriesTable()
    }
    
    func databasePath() -> String{
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("DocDir :: \(docDir)")
        return docDir + "/" + databaseName
    }
    
    func openDatabase(){
        if sqlite3_open(databasePath(), &database) == SQLITE_OK{
            print("Database opened successfully")
        }else{
            print("unable to open database")
        }
    }
    
    func createProductsTable(){
        
        let query = "create table \(DatabaseTable.Products.rawValue)(productId INTEGER , categoryId INTEGER , productName TEXT , dateAdded TEXT , taxName TEXT , taxValue Float , viewCount INTEGER , orderCount INTEGER , shares INTEGER , variantId INTEGER , color TEXT , size INTEGER , price INTEGER)"
        
        var statement:OpaquePointer?
        
        if sqlite3_prepare(database!, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement!) == SQLITE_DONE{
                print("Products table created successfully")
            }
        }
        sqlite3_finalize(statement)
    }
    
    func createCategoriesTable(){
        let query = "create table \(DatabaseTable.Category.rawValue)(categoryId INTEGER , categoryName TEXT , childCategories TEXT)"
        
        var statement:OpaquePointer?
        
        if sqlite3_prepare(database!, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement!) == SQLITE_DONE{
                print("Category table created successfully")
            }
        }
        sqlite3_finalize(statement)
    }
}
