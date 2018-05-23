//
//  ProductListVC.swift
//  ECommerse App
//
//  Created by Saurabh Prajapati on 21/02/18.
//  Copyright © 2018 Saurabh Prajapati. All rights reserved.
//

import UIKit

class ProductListVC: UIViewController {

    @IBOutlet var tblProductListing: UITableView!
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var lblNoProducts:UILabel!
    
    let cellIdentifier = "ProductListVCCell"
    var categoryList:CategoryList!
    var arrProducts = [ProductList]()
    
    var arrFilteredProducts = [ProductList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadProducts()
    }

    //MARK: - Button Actions -
    @IBAction func segmentDidChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            arrFilteredProducts = arrProducts
            break;
            
        case 1:
            arrFilteredProducts = arrProducts.filter({ (list) -> Bool in
                return list.viewCount > 0
            })
            
            arrFilteredProducts = arrFilteredProducts.sorted(by: { (list1, list2) -> Bool in
                return list1.viewCount > list2.viewCount
            })
            
            break;
        case 2:
            arrFilteredProducts = arrProducts.filter({ (list) -> Bool in
                return list.orderCount > 0
            })
            
            arrFilteredProducts = arrFilteredProducts.sorted(by: { (list1, list2) -> Bool in
                return list1.orderCount > list2.orderCount
            })
            
            break;
        case 3:
            arrFilteredProducts = arrProducts.filter({ (list) -> Bool in
                return list.shareCount > 0
            })
            
            arrFilteredProducts = arrFilteredProducts.sorted(by: { (list1, list2) -> Bool in
                return list1.shareCount > list2.shareCount
            })
            
            break;
            
        default:
            print("Unknown tab selected")
        }
        
        self.tblProductListing.reloadData()
        self.showHideNoProducts()
    }
    
    //MARK: - Private Methods -
    func reloadProducts(){
        arrProducts = ProductList.getRecord(by: categoryList.id)
        arrFilteredProducts = arrProducts
        self.tblProductListing.reloadData()
        showHideNoProducts()
    }
    
    
    func showHideNoProducts(){
        if arrFilteredProducts.count > 0{
            self.tblProductListing.isHidden = false
            self.lblNoProducts.isHidden = true
        }else{
            self.tblProductListing.isHidden = true
            self.lblNoProducts.isHidden = false
            self.lblNoProducts.text = "No Products Found"
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

extension ProductListVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFilteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productList = arrFilteredProducts[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ProductListVCCell
        cell.lblProductName.text = productList.name
        
        let strDateAdded = "Date Added: \(productList.dateAdded)"
        
        let range1 = (strDateAdded as NSString).range(of: "Date Added:")
        let attributedDate = NSMutableAttributedString(string: strDateAdded)
        attributedDate.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: range1)
        
        cell.lblDateAdded.attributedText = attributedDate
        
        let strTaxDetail = "\(productList.taxName): \(productList.taxValue)"
        
        let range2 = (strTaxDetail as NSString).range(of: "\(productList.taxName):")
        let attributedTax = NSMutableAttributedString(string: strTaxDetail)
        attributedTax.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: range2)
        cell.lblTaxDetail.attributedText = attributedTax
        
        let strPrice = "Price: \(productList.price)"
        let range3 = (strPrice as NSString).range(of: "Price:")
        let attributedPrice = NSMutableAttributedString(string: strPrice)
        attributedPrice.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: range3)
        cell.lblPrice.attributedText = attributedPrice
        
        let strSize = "Size: \(productList.size)"
        let range4 = (strSize as NSString).range(of: "Size:")
        let attributedSize = NSMutableAttributedString(string: strSize)
        attributedSize.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: range4)
        cell.lblSize.attributedText = attributedSize
        
        let strColor = "Color: \(productList.color)"
        let range5 = (strColor as NSString).range(of: "Color:")
        let attributedColor = NSMutableAttributedString(string: strColor)
        attributedColor.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: range5)
        cell.lblColor.attributedText = attributedColor
        
        return cell
    }
}
