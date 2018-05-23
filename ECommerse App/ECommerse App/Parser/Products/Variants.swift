
//
//  Varients.swift
//  ECommerse App
//
//  Created by Saurabh Prajapati on 20/02/18.
//  Copyright © 2018 Saurabh Prajapati. All rights reserved.
//

import Foundation
import SQLite3

class Variant:NSObject{
    var id:Int32 = 0
    var color:String = ""
    var size:Int32 = 0
    var price:Double = 0
    var productId:Int32 = 0
    
    class func insert(variants:[Variant]) {
        sqlite3_exec(AppDelegate.dbHelper.database!, "BEGIN", nil, nil, nil)
        
        let query = "insert into \(DBHelper.DatabaseTable.Variant)(variantId , productId, color, size, price) values(?,?,?,?,?);"
        
        var statement:OpaquePointer?
        
        if sqlite3_prepare(AppDelegate.dbHelper.database!, query, -1, &statement, nil) == SQLITE_OK{
            for variant in variants{
                
                var i:Int32 = 1
                
                sqlite3_bind_int(statement, i, variant.id)
                i += 1
                
                sqlite3_bind_int(statement, i, variant.productId)
                i += 1
                
                sqlite3_bind_text(statement, i, variant.color, -1, SQLITE_TRANSIENT)
                i += 1
                
                sqlite3_bind_int(statement, i, variant.size)
                i += 1
                
                sqlite3_bind_double(statement, i, variant.price)
                i += 1
                
                if sqlite3_step(statement) == SQLITE_DONE{
                    print("Variant inserted successfully")
                    sqlite3_reset(statement)
                }
            }
        }
        
        sqlite3_exec(AppDelegate.dbHelper.database, "COMMIT", nil, nil, nil)
        sqlite3_finalize(statement)
    }
    
    class func getAllRecords() -> [Variant]{
        let query = "select variantId , productId, color, size, price from \(DBHelper.DatabaseTable.Variant)"
        var statement:OpaquePointer?
        
        var arrVariants = [Variant]()
        if sqlite3_prepare(AppDelegate.dbHelper.database!, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW{
                
                let variant = Variant()
                var i:Int32 = 0
                
                variant.id = sqlite3_column_int(statement, i)
                i += 1
                
                variant.productId = sqlite3_column_int(statement, i)
                i += 1
                
                if let color = sqlite3_column_text(statement, i){
                    variant.color = String(cString:color)
                }
                i += 1
                
                variant.size = sqlite3_column_int(statement, i)
                i += 1
                
                variant.price = sqlite3_column_double(statement, i)
                i += 1
                
                arrVariants.append(variant)
            }
        }
        return arrVariants
    }
    
    class func getRecord(by id:Int32) -> Variant?{
        let query = "select variantId , productId, color, size, price from \(DBHelper.DatabaseTable.Variant) where variantId = '\(id)'"
        var statement:OpaquePointer?
        
        var variant:Variant?
        if sqlite3_prepare(AppDelegate.dbHelper.database!, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW{
                
                variant = Variant()
                var i:Int32 = 0
                
                variant!.id = sqlite3_column_int(statement, i)
                i += 1
                
                variant!.productId = sqlite3_column_int(statement, i)
                i += 1
                
                if let color = sqlite3_column_text(statement, i){
                    variant!.color = String(cString:color)
                }
                i += 1
                
                variant!.size = sqlite3_column_int(statement, i)
                i += 1
                
                variant!.price = sqlite3_column_double(statement, i)
                i += 1
            }
        }
        return variant
    }
    
    class func getRecord(by productId:Int32) -> [Variant]{
        let query = "select variantId , productId, color, size, price from \(DBHelper.DatabaseTable.Variant) where productId = '\(productId)'"
        var statement:OpaquePointer?
        
        var arrVariants = [Variant]()
        if sqlite3_prepare(AppDelegate.dbHelper.database!, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW{
                
                let variant = Variant()
                var i:Int32 = 0
                
                variant.id = sqlite3_column_int(statement, i)
                i += 1
                
                variant.productId = sqlite3_column_int(statement, i)
                i += 1
                
                if let color = sqlite3_column_text(statement, i){
                    variant.color = String(cString:color)
                }
                i += 1
                
                variant.size = sqlite3_column_int(statement, i)
                i += 1
                
                variant.price = sqlite3_column_double(statement, i)
                i += 1
                
                arrVariants.append(variant)
            }
        }
        return arrVariants
    }
    
    class func delete(by id:Int32){
        let query = "delete from \(DBHelper.DatabaseTable.Variant) where variantId = '\(id)'"
        var statement:OpaquePointer?
        
        if sqlite3_prepare(AppDelegate.dbHelper.database!, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE{
                print("Variant deleted")
            }
        }
        sqlite3_finalize(statement)
    }
    
    class func deleteAllRecords(){
        let query = "delete from \(DBHelper.DatabaseTable.Variant)"
        var statement:OpaquePointer?
        
        if sqlite3_prepare(AppDelegate.dbHelper.database!, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE{
                print("All Variants deleted successfully")
            }
        }
        sqlite3_finalize(statement)
    }

}
