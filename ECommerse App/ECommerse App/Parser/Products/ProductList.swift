//
//  ProductList.swift
//  ECommerse App
//
//  Created by Saurabh Prajapati on 20/02/18.
//  Copyright © 2018 Saurabh Prajapati. All rights reserved.
//

import UIKit
import SQLite3

class ProductList: NSObject {
    
    var categoryId:Int32 = 0
    
    var id:Int32 = 0
    var name:String = ""
    var dateAdded:String = ""
    var varients = [Variant]()
    var taxName:String = ""
    var taxValue:Double = 0
    
    var viewCount:Int32 = 0
    var shareCount:Int32 = 0
    var orderCount:Int32 = 0
    
    var variantId:Int32 = 0
    var color:String = ""
    var size:Int32 = 0
    var price:Double = 0
    
    func formattedDateAdded() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.sssZ"
        
        if let date = dateFormatter.date(from: self.dateAdded){
            dateFormatter.dateFormat = "dd-MM-yyyy 'at' hh:mm:ss"
            return dateFormatter.string(from: date)
        }else{
            return dateAdded
        }
    }
    
    class func insert(products:[ProductList]) {
        sqlite3_exec(AppDelegate.dbHelper.database!, "BEGIN", nil, nil, nil)
        
        let query = "insert into \(DBHelper.DatabaseTable.Products)(productId, categoryId, productName, dateAdded, taxName, taxValue, viewCount, orderCount, shares, variantId, color, size, price) values(?,?,?,?,?,?,?,?,?,?,?,?,?);"
        
        var statement:OpaquePointer?
        
        if sqlite3_prepare(AppDelegate.dbHelper.database!, query, -1, &statement, nil) == SQLITE_OK{
            for product in products{
                
                var i:Int32 = 1
                
                sqlite3_bind_int(statement, i, product.id)
                i += 1
                
                sqlite3_bind_int(statement, i, product.categoryId)
                i += 1
                
                sqlite3_bind_text(statement, i, product.name, -1, SQLITE_TRANSIENT)
                i += 1
                
                let formattedDate = product.formattedDateAdded()
                sqlite3_bind_text(statement, i, formattedDate, -1, SQLITE_TRANSIENT)
                i += 1
                
                sqlite3_bind_text(statement, i, product.taxName, -1, SQLITE_TRANSIENT)
                i += 1
                
                sqlite3_bind_double(statement, i, product.taxValue)
                i += 1
                
                sqlite3_bind_int(statement, i, product.viewCount)
                i += 1
                
                sqlite3_bind_int(statement, i, product.orderCount)
                i += 1
                
                sqlite3_bind_int(statement, i, product.shareCount)
                i += 1
                
                sqlite3_bind_int(statement, i, product.variantId)
                i += 1
                
                sqlite3_bind_text(statement, i, product.color, -1, SQLITE_TRANSIENT)
                i += 1
                
                sqlite3_bind_int(statement, i, product.size)
                i += 1
                
                sqlite3_bind_double(statement, i, product.price)
                i += 1
                
                if sqlite3_step(statement) == SQLITE_DONE{
                    print("Product inserted successfully")
                    sqlite3_reset(statement)
                }
            }
        }
        
        sqlite3_exec(AppDelegate.dbHelper.database, "COMMIT", nil, nil, nil)
        sqlite3_finalize(statement)
    }
    
    class func update(products:[ProductList]) {
        sqlite3_exec(AppDelegate.dbHelper.database!, "BEGIN", nil, nil, nil)
        
        let query = "update \(DBHelper.DatabaseTable.Products) set viewCount = ?, orderCount = ?, shares = ? where productId = ?"
        
        var statement:OpaquePointer?
        
        if sqlite3_prepare(AppDelegate.dbHelper.database!, query, -1, &statement, nil) == SQLITE_OK{
            for product in products{
                
                var i:Int32 = 1
                
                sqlite3_bind_int(statement, i, product.viewCount)
                i += 1
                
                sqlite3_bind_int(statement, i, product.orderCount)
                i += 1
                
                sqlite3_bind_int(statement, i, product.shareCount)
                i += 1
                
                sqlite3_bind_int(statement, i, product.id)
                i += 1
                
                if sqlite3_step(statement) == SQLITE_DONE{
                    print("Product updated successfully")
                    sqlite3_reset(statement)
                }
            }
        }
        
        sqlite3_exec(AppDelegate.dbHelper.database, "COMMIT", nil, nil, nil)
        sqlite3_finalize(statement)
    }
    
    class func getAllRecords() -> [ProductList]{
        let query = "select productId, categoryId, productName, dateAdded, taxName, taxValue, viewCount, orderCount, shares,variantId, color, size, price  from \(DBHelper.DatabaseTable.Products)"
        var statement:OpaquePointer?
        
        var arrProducts = [ProductList]()
        if sqlite3_prepare(AppDelegate.dbHelper.database!, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW{
                
                let productList = ProductList()
                var i:Int32 = 0
                
                productList.id = sqlite3_column_int(statement, i)
                i += 1
                
                productList.categoryId = sqlite3_column_int(statement, i)
                i += 1
                
                if let name = sqlite3_column_text(statement, i){
                    productList.name = String(cString:name)
                }
                i += 1
                
                if let dateAdded = sqlite3_column_text(statement, i){
                    productList.dateAdded = String(cString:dateAdded)
                }
                i += 1
                
                if let taxName = sqlite3_column_text(statement, i){
                    productList.taxName = String(cString:taxName)
                }
                i += 1
                
                productList.taxValue = sqlite3_column_double(statement, i)
                i += 1
                
                productList.viewCount = sqlite3_column_int(statement, i)
                i += 1
                
                productList.orderCount = sqlite3_column_int(statement, i)
                i += 1
                
                productList.shareCount = sqlite3_column_int(statement, i)
                i += 1
                
                productList.variantId = sqlite3_column_int(statement, i)
                i += 1
                
                if let color = sqlite3_column_text(statement, i){
                    productList.color = String(cString:color)
                }
                i += 1
                
                productList.size = sqlite3_column_int(statement, i)
                i += 1
                
                productList.price = sqlite3_column_double(statement, i)
                i += 1
                
                arrProducts.append(productList)
            }
        }
        return arrProducts
    }
    
    class func getRecord(by id:Int32) -> ProductList?{
        let query = "select productId, categoryId, productName, dateAdded, taxName, taxValue, viewCount, orderCount, shares,variantId, color, size, price from \(DBHelper.DatabaseTable.Products) where productId = '\(id)'"
        var statement:OpaquePointer?
        
        var productList:ProductList?
        if sqlite3_prepare(AppDelegate.dbHelper.database!, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW{
                
                productList = ProductList()
                var i:Int32 = 0
                
                productList!.id = sqlite3_column_int(statement, i)
                i += 1
                
                productList!.categoryId = sqlite3_column_int(statement, i)
                i += 1
                
                if let name = sqlite3_column_text(statement, i){
                    productList!.name = String(cString:name)
                }
                i += 1
                
                if let dateAdded = sqlite3_column_text(statement, i){
                    productList!.dateAdded = String(cString:dateAdded)
                }
                i += 1
                
                if let taxName = sqlite3_column_text(statement, i){
                    productList!.taxName = String(cString:taxName)
                }
                i += 1
                
                productList!.taxValue = sqlite3_column_double(statement, i)
                i += 1
                
                productList!.viewCount = sqlite3_column_int(statement, i)
                i += 1
                
                productList!.orderCount = sqlite3_column_int(statement, i)
                i += 1
                
                productList!.shareCount = sqlite3_column_int(statement, i)
                i += 1
                
                productList!.variantId = sqlite3_column_int(statement, i)
                i += 1
                
                if let color = sqlite3_column_text(statement, i){
                    productList!.color = String(cString:color)
                }
                i += 1
                
                productList!.size = sqlite3_column_int(statement, i)
                i += 1
                
                productList!.price = sqlite3_column_double(statement, i)
                i += 1
            }
        }
        return productList
    }
    
    class func getRecord(by category:Int32) -> [ProductList]{
        let query = "select productId, categoryId, productName, dateAdded, taxName, taxValue, viewCount, orderCount, shares,variantId, color, size, price from \(DBHelper.DatabaseTable.Products) where categoryId = '\(category)'"
        var statement:OpaquePointer?
        
        var arrProducts = [ProductList]()
        if sqlite3_prepare(AppDelegate.dbHelper.database!, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW{
                
                let productList = ProductList()
                var i:Int32 = 0
                
                productList.id = sqlite3_column_int(statement, i)
                i += 1
                
                productList.categoryId = sqlite3_column_int(statement, i)
                i += 1
                
                if let name = sqlite3_column_text(statement, i){
                    productList.name = String(cString:name)
                }
                i += 1
                
                if let dateAdded = sqlite3_column_text(statement, i){
                    productList.dateAdded = String(cString:dateAdded)
                }
                i += 1
                
                if let taxName = sqlite3_column_text(statement, i){
                    productList.taxName = String(cString:taxName)
                }
                i += 1
                
                productList.taxValue = sqlite3_column_double(statement, i)
                i += 1
                
                productList.viewCount = sqlite3_column_int(statement, i)
                i += 1
                
                productList.orderCount = sqlite3_column_int(statement, i)
                i += 1
                
                productList.shareCount = sqlite3_column_int(statement, i)
                i += 1
                
                productList.variantId = sqlite3_column_int(statement, i)
                i += 1
                
                if let color = sqlite3_column_text(statement, i){
                    productList.color = String(cString:color)
                }
                i += 1
                
                productList.size = sqlite3_column_int(statement, i)
                i += 1
                
                productList.price = sqlite3_column_double(statement, i)
                i += 1
                
                arrProducts.append(productList)
            }
        }
        return arrProducts
    }
    
    class func delete(by id:Int32){
        let query = "delete from \(DBHelper.DatabaseTable.Products) where id = '\(id)'"
        var statement:OpaquePointer?
        
        if sqlite3_prepare(AppDelegate.dbHelper.database!, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE{
                print("Product deleted")
            }
        }
        sqlite3_finalize(statement)
    }
    
    class func deleteAllRecords(){
        let query = "delete from \(DBHelper.DatabaseTable.Products)"
        var statement:OpaquePointer?
        
        if sqlite3_prepare(AppDelegate.dbHelper.database!, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE{
                print("All Products deleted successfully")
            }
        }
        sqlite3_finalize(statement)
    }
}
