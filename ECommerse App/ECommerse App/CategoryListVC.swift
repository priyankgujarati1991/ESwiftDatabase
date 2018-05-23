//
//  ViewController.swift
//  ECommerse App
//
//  Created by Saurabh Prajapati on 20/02/18.
//  Copyright © 2018 Saurabh Prajapati. All rights reserved.
//

import UIKit

class CategoryListVC: UIViewController {

    @IBOutlet weak var tblCategories: UITableView!
    
    private var arrCategories = [CategoryList]()
    let cellIdentifier = "CategoryListCell"
    
    var selectedCategory:CategoryList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
        getProductLists()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProducts"{
            if segue.destination is ProductListVC{
                let productVC = segue.destination as! ProductListVC
                productVC.categoryList = selectedCategory
            }
        }
    }
    
    //MARK: - Private Methods -
    /// This method is used to show activity indicator
    func showActivityIndicator(){
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    /// This method is used to hide activity indicator
    func hideActivityIndicator(){
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    /// this method is used to reload category listing
    func reloadData(){
        self.arrCategories = CategoryList.getAllRecords()
        self.tblCategories.reloadData()
    }
}

extension CategoryListVC: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        let categoryList = arrCategories[indexPath.row]
        
        cell?.textLabel?.text = categoryList.name
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        cell?.accessoryType = .disclosureIndicator
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = arrCategories[indexPath.row]
        self.performSegue(withIdentifier: "showProducts", sender: self)
    }
}

extension CategoryListVC: ProductParserDelegate{
    func getProductLists() {
        ///this will call api only when there is no categories availablein databse
        /// will change later
        if AppDelegate.shared.isInternetReachable && arrCategories.count == 0{
            showActivityIndicator()
            let parser = ProductParser()
            parser.delegate = self
            parser.getProducts()
        }
    }
    
    func productParsingSuccess() {
        DispatchQueue.main.async {
            self.reloadData()
        }
        hideActivityIndicator()
    }
    
    func productParsingFailure(message: String){
        DispatchQueue.main.async {
            self.reloadData()
            
            if self.arrCategories.count == 0{
                let alert = UIAlertController(title: "E-Commerse App", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                    CategoryList.deleteAllRecords()
                    ProductList.deleteAllRecords()
                }))
            }
        }
        hideActivityIndicator()
    }
}

