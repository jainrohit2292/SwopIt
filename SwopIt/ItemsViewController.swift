//
//  ItemsViewController.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 2/25/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import MBProgressHUD

class ItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TopBarItemsProtocol, ItemProtocol {
    var items: [Item] = [Item]()
    @IBOutlet weak var itemsTableView: UITableView!
   
    @IBOutlet weak var categoriesView: UIView!
    @IBOutlet weak var subCategoryCollectionView: UICollectionView!
    @IBOutlet weak var categoriesViewHeightConstraint: NSLayoutConstraint!
    var selectedCategory:Category?
    var selectedSubCategory:SubCategory?
    var catImagesDict : [String:UIImage?]?
    var selectedCatImagesDict : [String:UIImage?]?
    var subCatImagesDict : [String:UIImage?]?
    var selectedSubCatImagesDict : [String:UIImage?]?
    var cats : [Category]?
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    var delegate: SwopItTabBarHandlerProtocol?

    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, cats: [Category], catImagesDict: [String: UIImage?], selectedCatImagesDict: [String: UIImage?], subCatImagesDict : [String: UIImage?],selectedSubCatImagesDict:[String: UIImage?], delegate: SwopItTabBarHandlerProtocol) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.cats = cats
        self.catImagesDict =  catImagesDict
        self.subCatImagesDict = subCatImagesDict
        self.selectedCatImagesDict = selectedCatImagesDict
        self.selectedSubCatImagesDict = selectedSubCatImagesDict
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemsTableView.delegate = self
        self.itemsTableView.dataSource = self
        let cellnib = UINib(nibName: "ItemsListTableViewCell", bundle: nil)
        self.itemsTableView.register(cellnib, forCellReuseIdentifier: "ItemsListTableViewCell")
        let collCellNib =  UINib(nibName: "CategoriesCollectionViewCell", bundle: nil)
        self.categoriesCollectionView.register(collCellNib, forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
        self.subCategoryCollectionView.register(collCellNib, forCellWithReuseIdentifier: "CategoriesCollectionViewCell2")
        self.subCategoryCollectionView.delegate = self
        self.subCategoryCollectionView.dataSource = self
        self.categoriesCollectionView.delegate = self
        self.categoriesCollectionView.dataSource = self
        self.categoriesCollectionView.isHidden = true
        self.categoriesView.isHidden = true
        self.categoriesViewHeightConstraint.constant = 0
        
        
//        print("Lat : "+Utils.getUserLocationFromPrefs().latitude)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getItemsByDistance()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(_tableView: UITableView) -> Int{
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if(indexPath.row < self.items.count){
        let cell: ItemsListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ItemsListTableViewCell", for: indexPath as IndexPath) as! ItemsListTableViewCell
        cell.updateCell(item: self.items[indexPath.row], indexPath: indexPath, delegate: self)
        cell.selectionStyle = .none
        return cell
        }
        else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(self.items.count <= 0){
            self.itemsTableView.isHidden = true
            return 0
        }
        else{
            self.itemsTableView.isHidden = false
            return (self.items.count + 1)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if(indexPath.row < self.items.count){
            return 322
        }
        return 49.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if(collectionView == self.categoriesCollectionView){
            return self.cats!.count
        }
        else if(self.selectedCategory != nil){
            return (self.selectedCategory?.subCategories?.count)!
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if(collectionView == self.categoriesCollectionView){
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as! CategoriesCollectionViewCell
            if(self.selectedCategory != nil){
                if(self.selectedCategory?.name! == self.cats![indexPath.row].name!){
                    cell.catLbl.textColor = UIColor(colorLiteralRed: 17.0/255.0, green: 115.0/255.0, blue: 45.0/255.0, alpha: 1.0)
                    cell.updateCell(image: self.selectedCatImagesDict![self.cats![indexPath.row].name!]! , title: self.cats![indexPath.row].name!)
                }
                else{
                    cell.catLbl.textColor = UIColor(colorLiteralRed: 182.0/255.0, green: 178.0/255.0, blue: 186.0/255.0, alpha: 1.0)
                     cell.updateCell(image: self.catImagesDict![self.cats![indexPath.row].name!]! , title: self.cats![indexPath.row].name!)
                }
            }
            else{
                cell.catLbl.textColor = UIColor(colorLiteralRed: 182.0/255.0, green: 178.0/255.0, blue: 186.0/255.0, alpha: 1.0)
                cell.updateCell(image: self.catImagesDict![self.cats![indexPath.row].name!]! , title: self.cats![indexPath.row].name!)
            }
        return cell
        }
        else if(collectionView == self.subCategoryCollectionView){
            if(self.selectedCategory != nil){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell2", for: indexPath) as! CategoriesCollectionViewCell
                let subCats = self.selectedCategory!.subCategories!
                let subCatName = (subCats[indexPath.row].name!)
                let img = self.subCatImagesDict![subCatName]
                if(img == nil){
                    cell.catLbl.textColor = UIColor(colorLiteralRed: 182.0/255.0, green: 178.0/255.0, blue: 186.0/255.0, alpha: 1.0)
                    cell.updateCell(image: nil , title: self.selectedCategory!.subCategories![indexPath.row].name!)
                }
                else{
                    if(self.selectedSubCategory?.name! == self.selectedCategory!.subCategories![indexPath.row].name!){
                        let selectedName = self.selectedSubCategory!.name!
                        cell.catLbl.textColor = UIColor(colorLiteralRed: 17.0/255.0, green: 115.0/255.0, blue: 45.0/255.0, alpha: 1.0)
                        cell.updateCell(image: self.selectedSubCatImagesDict![selectedName]! , title: self.selectedCategory!.subCategories![indexPath.row].name!)
                    }
                    else{
                        cell.catLbl.textColor = UIColor(colorLiteralRed: 182.0/255.0, green: 178.0/255.0, blue: 186.0/255.0, alpha: 1.0)
                        cell.updateCell(image: img! , title: self.selectedCategory!.subCategories![indexPath.row].name!)
                    }
                }
            
            return cell
            }
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        return  CGSize(width: UIScreen.main.bounds.width/3 , height: 50)
    }
    func getAllItemsByUserId(){
        let url = Constants.GET_ITEM_BY_USER_ID_URL
        let params = [Constants.KEY_USER_ID :  Utils.getLoggedInUserId()]
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: url, params: params as [String : AnyObject]?, httpMethod: Constants.HTTP_METHOD_POST) { (resp) in
        MBProgressHUD.hide(for: self.view, animated: false)
            let respCode = (resp?[Constants.KEY_RESPONSE_CODE] as! Int)
            print("Response : \(resp)")
            if(respCode == 1){
                self.items = ModelFactory.createItemsList(dict: resp!)
                self.itemsTableView.reloadData()
            }
        }
    }
    
    
    
    func getItemsByDistance(){
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network.", vc: self)
            return
        }
        let url = Constants.GET_ITEM_BY_DISTANCE
        print("User Id : \(Utils.getLoggedInUserId())")
        var params = [Constants.KEY_DISTANCE: Utils.getCurrentDistancePreference()]
        if(Utils.isUserLoggedin()){
            params = [Constants.KEY_USER_ID :  Utils.getLoggedInUserId(), Constants.KEY_DISTANCE: Utils.getCurrentDistancePreference()]
        }
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: url, params: params as [String : AnyObject]?, httpMethod: Constants.HTTP_METHOD_POST) { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            let respCode = (resp?[Constants.KEY_RESPONSE_CODE] as! Int)
            print("Response : \(resp)")
            if(respCode == 1){
                self.items = ModelFactory.createItemsList(dict: resp!)
                self.itemsTableView.reloadData()
            }
            else{
                self.items = [Item]()
                self.itemsTableView.reloadData()
            }
        }
    }
    func getItemsBySubCategoryAndDistance(){
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network, and try again", vc: self)
            return
        }
        let url = Constants.GET_ITEMS_BY_CATEGORY
        var params = [Constants.KEY_DISTANCE: Utils.getCurrentDistancePreference(), Constants.KEY_SUBCATEGORY_ID: self.selectedSubCategory?.id!]
        if(Utils.isUserLoggedin()){
            params = [Constants.KEY_USER_ID :  Utils.getLoggedInUserId(), Constants.KEY_DISTANCE: Utils.getCurrentDistancePreference(), Constants.KEY_SUBCATEGORY_ID: self.selectedSubCategory?.id!]
        }
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: url, params: params as [String : AnyObject]?, httpMethod: Constants.HTTP_METHOD_POST) { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            let respCode = (resp?[Constants.KEY_RESPONSE_CODE] as! Int)
            print("Response : \(resp)")
            if(respCode == 1){
                self.items = ModelFactory.createItemsList(dict: resp!)
                self.itemsTableView.reloadData()
            }
        }
    }
    func getItemsByCategoryAndDistance(){
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network, and try again", vc: self)
            return
        }
        let url = Constants.GET_ITEMS_BY_CATEGORY
        var params = [Constants.KEY_DISTANCE: Utils.getCurrentDistancePreference(), Constants.KEY_CATEGORY: self.selectedCategory?.name!]
        if(Utils.isUserLoggedin()){
            params = [Constants.KEY_USER_ID :  Utils.getLoggedInUserId(), Constants.KEY_DISTANCE: Utils.getCurrentDistancePreference(), Constants.KEY_CATEGORY: self.selectedCategory?.name!]
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: url, params: params as [String : AnyObject]?, httpMethod: Constants.HTTP_METHOD_POST) { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            let respCode = (resp?[Constants.KEY_RESPONSE_CODE] as! Int)
            print("Response : \(resp)")
            if(respCode == 1){
                self.items = ModelFactory.createItemsList(dict: resp!)
                self.itemsTableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.getItemDetails(itemId: self.items[indexPath.row].itemId!, rowNum: indexPath.row)
    }
    func getItemDetails(itemId: String, rowNum: Int){
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network, and try again", vc: self)
            return
        }
        let params = [Constants.KEY_ITEM_ID : itemId]
        let url = Constants.GET_ITEM_DETAIL_BY_ID
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: url, params: params as [String : AnyObject]?, httpMethod: Constants.HTTP_METHOD_POST) { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            print("Response : \(resp)")
            if((resp?[Constants.KEY_RESPONSE_CODE] as! Int) == 1){
                let itm = Item(dict: resp?[Constants.KEY_RESPONSE] as! [String: AnyObject])
                if(itm.distance ==  nil){
                    itm.distance = self.items[rowNum].distance!
                }
                if(itm.urls.count == 0){
                    itm.urls = self.items[rowNum].urls
                }
                if(itm.user ==  nil){
                    itm.user = self.items[rowNum].user
                }
                let idvc = ItemDetailsViewController(nibName: "ItemDetailsViewController", bundle: nil, item: itm)
                self.delegate?.presentVC(vc: idvc)
            }
        }
    }
    
    func toggleCategoryVisibilty(){
        self.categoriesCollectionView.isHidden = !self.categoriesCollectionView.isHidden
        self.categoriesView.isHidden = !self.categoriesView.isHidden
        if(!self.categoriesCollectionView.isHidden){
            self.categoriesViewHeightConstraint.constant = 150
        }
        else{
            self.categoriesViewHeightConstraint.constant = 0
            self.refreshAfterCategoriesClosed()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if(collectionView == self.categoriesCollectionView){
            self.selectedCategory = self.cats?[indexPath.row]
            self.subCategoryCollectionView.reloadData()
            self.categoriesCollectionView.reloadData()
            self.getItemsByCategoryAndDistance()
        }
        else if(collectionView == self.subCategoryCollectionView){
            self.selectedSubCategory = self.selectedCategory?.subCategories?[indexPath.row]
            self.subCategoryCollectionView.reloadData()
            self.getItemsBySubCategoryAndDistance()
            
        }
    }
    func goToItemDetails(item: Item, indexPath: IndexPath){
        self.getItemDetails(itemId: item.itemId!, rowNum: indexPath.row)
    }
    func searchItemBy(text: String){
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network, and try again", vc: self)
            return
        }
        let url = Constants.GET_ITEM_BY_SEARCH
        //Constants.KEY_USER_ID :  Utils.getLoggedInUserId(),
        let params = [Constants.KEY_DISTANCE: Utils.getCurrentDistancePreference(), Constants.KEY_SEARCH_TEXT: text]
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: url, params: params as [String : AnyObject]?, httpMethod: Constants.HTTP_METHOD_POST) { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            let respCode = (resp?[Constants.KEY_RESPONSE_CODE] as! Int)
            print("Response : \(resp)")
            if(respCode == 1){
                self.items = ModelFactory.createItemsList(dict: resp!)
                self.itemsTableView.reloadData()
            }
        }
    }
    func refreshAfterSearch(){
        self.getItemsByDistance()
    }
    func refreshAfterCategoriesClosed(){
        self.getItemsByDistance()
    }
    func goToUserProfile(userId : String){
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil, userId: userId)
        self.delegate?.presentVC(vc: profileVC)
    }
}
