//
//  ProductParser.swift
//  ECommerse App
//
//  Created by Saurabh Prajapati on 20/02/18.
//  Copyright © 2018 Saurabh Prajapati. All rights reserved.
//

import UIKit

protocol ProductParserDelegate {
    func productParsingSuccess()
    func productParsingFailure(message:String)
}

class ProductParser: NSObject {
    
    var delegate:ProductParserDelegate!
    
    func getProducts(){
        if let url = Utils.shared.getAPIURL(for: .Products){
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if error == nil{
                    if data != nil{
                        self.parse(data:data!)
                    }else{
                        self.delegate.productParsingFailure(message: "no data found")
                    }
                }else{
                    //error while parsing API
                    self.delegate.productParsingFailure(message: error!.localizedDescription)
                }
            })
            dataTask.resume()
        }
    }
    
    func parse(data:Data){
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
            
            let categories = json["categories"] as! [[String:Any]]
            let rankings = json["rankings"] as! [[String:Any]]
            
            var arrCategories = [CategoryList]()
            for category in categories{
                
                let categoryList = CategoryList()
                
                if let id = category["id"] as? Int32{
                    categoryList.id = id
                }
                
                if let name = category["name"] as? String{
                    categoryList.name = name
                }
                
                var arrProducts = [ProductList]()
                if let products = category["products"] as? [[String:Any]]{
                    for product in products{
                        let productList = ProductList()
                        productList.categoryId = categoryList.id
                        
                        if let id = product["id"] as? Int32{
                            productList.id = id
                        }
                        
                        if let name = product["name"] as? String{
                            productList.name = name
                        }
                        
                        if let dateAdded = product["date_added"] as? String{
                            productList.dateAdded = dateAdded
                        }
                        
                        if let tax = product["tax"] as? [String:Any]{
                            if let name = tax["name"] as? String{
                                productList.taxName = name
                            }
                            
                            if let value = tax["value"] as? Double{
                                productList.taxValue = value
                            }
                        }
                        
                        if let variants = product["variants"] as? [[String:Any]],variants.count > 0{
                            for varient in variants{
                                
                                let newProductList = ProductList()
                                
                                newProductList.categoryId = productList.categoryId
                                newProductList.id = productList.id
                                newProductList.name = productList.name
                                newProductList.dateAdded = productList.dateAdded
                                newProductList.taxName = productList.taxName
                                newProductList.taxValue = productList.taxValue
                                
                                if let id = varient["id"] as? Int32{
                                    newProductList.variantId = id
                                }
                                
                                if let color = varient["color"] as? String{
                                    newProductList.color = color
                                }
                                
                                if let size = varient["size"] as? Int32{
                                    newProductList.size = size
                                }
                                
                                if let price = varient["price"] as? Double{
                                    newProductList.price = price
                                }
                                arrProducts.append(newProductList)
                            }
                        }else{
                            arrProducts.append(productList)
                        }
                    }
                    ProductList.insert(products: arrProducts)
                }
                
                categoryList.products = arrProducts
                
                if let childCategories = category["child_categories"] as? [Int32]{
                    categoryList.childCategories = childCategories
                }
                
                arrCategories.append(categoryList)
            }
            
            CategoryList.insert(arrCategories)
            
            for ranking in rankings{
                var arrProducts = [ProductList]()
                
                if let products = ranking["products"] as? [[String:Any]]{
                    for product in products{
                        let productList = ProductList()
                        
                        if let id = product["id"] as? Int32{
                            productList.id = id
                        }
                        
                        if let viewCount = product["view_count"] as? Int32{
                            productList.viewCount = viewCount
                        }
                        
                        if let orderCount = product["order_count"] as? Int32{
                            productList.orderCount = orderCount
                        }
                        
                        if let shareCount = product["shares"] as? Int32{
                            productList.shareCount = shareCount
                        }
                        arrProducts.append(productList)
                    }
                }
                
                ProductList.update(products: arrProducts)
            }
            
            self.delegate.productParsingSuccess()
            print("parsing successfully categories ::\(arrCategories.count)")
            
        }catch{
            print("Error while parsing data :: \(error.localizedDescription)")
            self.delegate.productParsingFailure(message: error.localizedDescription)
        }
    }
}
