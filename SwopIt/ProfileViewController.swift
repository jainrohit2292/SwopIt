//
//  ProfileViewController.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 2/24/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreGraphics
import PhotosUI
import SDWebImage
import Alamofire

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, IAHelperProtocol, SwopRequestProtocol{
    @IBOutlet weak var itemsAndCategoryView: UIView!
    @IBOutlet weak var profileImageV: UIImageView!
    var items: [Item] = [Item]()
    var swopFriends = [User]()
    var pastSwops = [SwopRequest]()
    @IBOutlet weak var swopHistoryTableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    var user : User?
    var userId: String?
    var selectedCategory:Category?
    var productsAvailable = false
    var cats : [Category] = [Category]()
    var isDSSwop = false
    var selectedItems: [Item] = [Item]()
    @IBOutlet weak var buyCoinsVIewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var loggedInUserSwopHistoryTableView: UITableView!
    @IBOutlet weak var swopFriendsCollectionView: UICollectionView!
    @IBOutlet weak var segmentControlView: UIView!
    
    @IBOutlet weak var dsSwopView: UIView!
    
    @IBOutlet weak var buyCoinsView: UIView!
    @IBOutlet weak var buyCoinsParentVieHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var swoppedItemsTableView: UITableView!
    let categories = [[UIImage(named:"fashion_inactive"), "Fashion"], [UIImage(named:"electronics_inactive"), "Electronics"],[UIImage(named:"cosmetics_inactive"), "Cosmetics"], [UIImage(named:"furniture_inactive"), "Furniture"]]
    let catImagesDict : [String : UIImage?] = ["Fashion" : UIImage(named:"fashion_inactive"), "Electronics" : UIImage(named:"electronics_inactive"), "Book & Art" : UIImage(named:"bookandart_inactive")]
    let selectedCatImagesDict : [String : UIImage?] = ["Fashion" : UIImage(named:"fashion_active"), "Electronics" : UIImage(named:"electronics_active"), "Book & Art" : UIImage(named:"bookandart_active")]
    
    let subCatImagesDict = ["Accessories" : UIImage(named:"accessories_inactive"), "Dress" : UIImage(named:"dres_inactive"), "Shoes" : UIImage(named:"shoe_inactive"), "Mobile" : UIImage(named:"mobile_inactive"), "iPad & Laptops" : UIImage(named:"laptop_inactive"), "Electronics" : UIImage(named:"electronics_inactive"), "Art" : UIImage(named:"art_inactive"), "Books" : UIImage(named:"bookandart_inactive"), "Films" : UIImage(named:"films_inactive")]
    let selectedSubCatImages = ["Accessories" : UIImage(named:"accessories_active"), "Dress" : UIImage(named:"dres_active"), "Shoes" : UIImage(named:"shoe_active"), "Mobile" : UIImage(named:"mobile_active"), "iPad & Laptops" : UIImage(named:"laptop_active"), "Electronics" : UIImage(named:"electronics_active"), "Art" : UIImage(named:"art_active"), "Books" : UIImage(named:"bookandart_active"), "Films" : UIImage(named:"films_active")]
    
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, userId:String) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.userId = userId
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, userId:String, isDSSwop: Bool) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.userId = userId
        self.isDSSwop = isDSSwop
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileImageV.layer.cornerRadius = self.profileImageV.frame.width/2
        self.profileImageV.clipsToBounds = true
        if(self.userId != nil){
            if(self.isDSSwop){
                self.dsSwopView.isHidden = false
                self.segmentControl.isHidden = true
                self.swopFriendsCollectionView.isHidden = true
                self.getItemsByUserId()
            }
            else{
            self.itemsAndCategoryView.isHidden = false
            let collCellNib =  UINib(nibName: "CategoriesCollectionViewCell", bundle: nil)
            self.categoriesCollectionView.register(collCellNib, forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
                let collCellNib2 =  UINib(nibName: "SwopFriendsCollectionViewCell", bundle: nil)
                self.swopFriendsCollectionView.register(collCellNib2, forCellWithReuseIdentifier: "SwopFriendsCollectionViewCell")
            self.getAllCategories()
            self.categoriesCollectionView.delegate = self
            self.categoriesCollectionView.dataSource = self
            self.swopFriendsCollectionView.delegate = self
            self.swopFriendsCollectionView.dataSource = self
            self.dsSwopView.isHidden = true
            self.segmentControl.isHidden = false
            self.swopFriendsCollectionView.isHidden = true
            self.swopHistoryTableView.delegate = self
                self.swopHistoryTableView.dataSource = self
            let cellNibTV = UINib(nibName: "SwopHistoryTableViewCell", bundle: nil)
               
            self.swopHistoryTableView.register(cellNibTV, forCellReuseIdentifier: "SwopHistoryTableViewCell")
            
            self.getSwopFriends()
            
            }
            self.swoppedItemsTableView.delegate = self
            self.swoppedItemsTableView.dataSource = self
            let cellnib2 = UINib(nibName: "SwoppedItemTableViewCell", bundle: nil)
            self.swoppedItemsTableView.register(cellnib2, forCellReuseIdentifier: "SwoppedItemTableViewCell")
        }
        else{
            self.itemsAndCategoryView.isHidden = true
             self.dsSwopView.isHidden = true
            self.segmentControl.isHidden = false
        }
         let cellNibTV1 = UINib(nibName: "SwopHistoryTableViewCell", bundle: nil)
        self.loggedInUserSwopHistoryTableView.register(cellNibTV1, forCellReuseIdentifier: "SwopHistoryTableViewCell")
        self.loggedInUserSwopHistoryTableView.delegate = self
        self.loggedInUserSwopHistoryTableView.dataSource = self
        self.getPastSwopRequests()
        ProfileViewController.iaHelper = IAPHelper(delegate: self)
       self.getIAProducts()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(self.userId == nil){
//         self.logoutBtn.isHidden = false
         self.editBtn.isHidden = false
         self.getLoggedInUserDetails()
        }
        else{
            self.editBtn.isHidden = true
            self.logoutBtn.isHidden = true
            self.getUserDetails()
            
        }
    }
    
    func loadProfileInfo(){
        self.nameLbl.text = self.user?.username!//Utils.getLoggedInUserName()
        if let profUrl = self.user!.profilePictureUrl{
            print("Profile Url : \(profUrl)")
            self.profileImageV.sd_setImage(with: URL(string: Constants.GET_PROFILE_PIC_URL + profUrl), placeholderImage: UIImage(named:"profile_placeholder"))
        }
        self.aboutLbl.text = self.user!.about!
    }
    
    func getLoggedInUserDetails(){
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network.", vc: self)
            return
        }
        let params = [Constants.KEY_USER_ID: Utils.getLoggedInUserId()]
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: Constants.GET_USER_DETAILS_BY_ID, params: params as [String : AnyObject]?, httpMethod: "POST") { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if((resp?[Constants.KEY_RESPONSE_CODE] as! Int) == 1){
                self.user = ModelFactory.createUser(dict: resp!)
                
                if(Utils.saveUserToPrefs(user: self.user!)){
                    self.loadProfileInfo()
                }
            }

        }
    }
    func getUserDetails(){
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network.", vc: self)
            return
        }
        let params = [Constants.KEY_USER_ID: self.userId!]
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: Constants.GET_USER_DETAILS_BY_ID, params: params as [String : AnyObject]?, httpMethod: "POST") { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if((resp?[Constants.KEY_RESPONSE_CODE] as! Int) == 1){
                self.user = ModelFactory.createUser(dict: resp!)
                if(self.userId == nil){
                if(Utils.saveUserToPrefs(user: self.user!)){
                    self.loadProfileInfo()
                }
                }
                else{
                    self.loadProfileInfo()
                }
            }
            
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateProfileImage(){
        if(self.userId == nil){
            self.presentImagePickingOptions()
        }
    }
    
    func isItemAlreadySelected(item: Item) -> Bool{
        for itm in self.selectedItems{
            if(itm.itemId! == item.itemId!){
                return true
            }
        }
        return false
    }
    
    func presentImagePickingOptions(){
        let alert = UIAlertController(title: "SwopIt", message: "Profile Image", preferredStyle: UIAlertControllerStyle.alert)
        let alertActionCamera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
            let picker: UIImagePickerController = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            self.present(picker, animated: false) {
                
            }
            
        })
        alert.addAction(alertActionCamera)
        
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
            let picker: UIImagePickerController = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .savedPhotosAlbum
            self.present(picker, animated: false) {
                
            }
        })
        alert.addAction(galleryAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            MBProgressHUD.showAdded(to: self.view, animated: false)
            
            if(!Reachability.isConnectedToNetwork()){
                Utils.showAlert(title: "SwopIt", msg: "Pease connect to network, and try again", vc: self)
                return
            }
            
            let urlStr = Constants.UPLOAD_PROFILE_PIC_URL + "/" + Utils.getLoggedInUserId()
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                let img = Utils.imageWithImage(image: pickedImage, scaledToSize: CGSize(width: 100, height: 100))
                let imgData = UIImagePNGRepresentation(img)
                multipartFormData.append(imgData!, withName: "profileImg", fileName: "profilePic.png", mimeType: "image/jpg")
            }, to:urlStr)
            { (result) in
                MBProgressHUD.hide(for: self.view, animated: false)
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        Utils.showAlert(title: "SwopIt", msg: "Profile picture uploaded successfully.", vc: self)
                        self.profileImageV.image = pickedImage
                    }
                case .failure( _):
                    Utils.showAlert(title: "SwopIt", msg: "Uploading Picture Please Error try again.", vc: self)
                }
            }
            
            picker.dismiss(animated: false, completion: {
                
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
    
        picker.dismiss(animated: false, completion: {
            
        })
    }
    @IBAction func goToEditProfile(_ sender: Any) {
        self.present(UpdateProfileViewController(), animated: false) { 
            
        }
        
    }
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: false) { 
            
        }
    }

    @IBAction func updateProfileImage(_ sender: Any) {
        self.updateProfileImage()
    }
    
    @IBAction func logOut(_ sender: Any) {
        let alert = UIAlertController(title: "SwopIt", message: "Are you sure to log out?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
            self.performLogout()
        }))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func performLogout() {
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network.", vc: self)
            return
        }
        let defaults = UserDefaults.standard
        let name = (defaults.value(forKey: Constants.KEY_USERNAME) as! String)
        let params = ["Username": name]
        
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: Constants.LOGOUT_URL, params: params as [String : AnyObject]?, httpMethod: Constants.HTTP_METHOD_POST) { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if((resp?[Constants.KEY_RESPONSE_CODE] as! Int) == 1){
                let defaults = UserDefaults.standard
                defaults.removeObject(forKey: Constants.KEY_USER_ID)
                defaults.removeObject(forKey: Constants.KEY_USERNAME)
                defaults.removeObject(forKey: Constants.KEY_NAME)
                defaults.removeObject(forKey: Constants.KEY_PROFILE_PICTURE)
                self.dismiss(animated: false, completion: nil)
            }
            else{
                Utils.showAlert(title: "SwopIt", msg: "Cannot logout please try again.", vc: self)
            }
        }
    }
    
    func getAllCategories(){
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network.", vc: self)
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: Constants.GET_ALL_CATEGORIES_URL, params: nil, httpMethod: "GET") { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if(resp != nil){
                self.cats = ModelFactory.createCategoriesList(dict: resp!)
                print("Cats Count : \(self.cats.count)")
                for cat in self.cats{
                    print("Category Name : "+cat.name!)
                }
                self.categoriesCollectionView.reloadData()
            }
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if(collectionView == self.swopFriendsCollectionView){
            return self.swopFriends.count
        }
            return self.cats.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if(collectionView == self.swopFriendsCollectionView){
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwopFriendsCollectionViewCell", for: indexPath) as! SwopFriendsCollectionViewCell
            cell.updateCell(user: self.swopFriends[indexPath.row])
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as! CategoriesCollectionViewCell
            if(self.selectedCategory != nil){
                if(self.selectedCategory?.name! == self.cats[indexPath.row].name!){
                    cell.catLbl.textColor = UIColor(colorLiteralRed: 17.0/255.0, green: 115.0/255.0, blue: 45.0/255.0, alpha: 1.0)
                    cell.updateCell(image: self.selectedCatImagesDict[self.cats[indexPath.row].name!]! , title: self.cats[indexPath.row].name!)
                }
                else{
                    cell.catLbl.textColor = UIColor(colorLiteralRed: 182.0/255.0, green: 178.0/255.0, blue: 186.0/255.0, alpha: 1.0)
                    cell.updateCell(image: self.catImagesDict[self.cats[indexPath.row].name!]! , title: self.cats[indexPath.row].name!)
                }
            }
            else{
                cell.catLbl.textColor = UIColor(colorLiteralRed: 182.0/255.0, green: 178.0/255.0, blue: 186.0/255.0, alpha: 1.0)
                cell.updateCell(image: self.catImagesDict[self.cats[indexPath.row].name!]! , title: self.cats[indexPath.row].name!)
            }
            return cell
        }
        }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        if(collectionView == self.swopFriendsCollectionView){
            return  CGSize(width: UIScreen.main.bounds.width/2 , height: 60)
        }
        return  CGSize(width: UIScreen.main.bounds.width/3 , height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
            self.selectedCategory = self.cats[indexPath.row]
//        if(self.segmentControl.selectedSegmentIndex == 0){
//            self.categoriesCollectionView.reloadData()
//            self.getItemsByCategoryAndUserId()
//        }
    }
    
    @IBAction func onSegmentChanged(_ sender: Any) {
//        if(segmentControl.selectedSegmentIndex == 0){
//            self.swoppedItemsTableView.isHidden = false
//            self.swopFriendsCollectionView.isHidden = true
//            self.swopHistoryTableView.isHidden = true
//            self.categoriesCollectionView.reloadData()
//            self.getItemsByCategoryAndUserId()
//        }
        if(segmentControl.selectedSegmentIndex == 0){
            self.swoppedItemsTableView.isHidden = true
            self.swopFriendsCollectionView.isHidden = true
            self.swopHistoryTableView.isHidden = false
        }
        else if(segmentControl.selectedSegmentIndex == 1){
            self.swoppedItemsTableView.isHidden = true
            self.swopFriendsCollectionView.isHidden = false
            self.swopHistoryTableView.isHidden = true
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if(tableView == self.swopHistoryTableView || tableView == self.loggedInUserSwopHistoryTableView ){
            let cell: SwopHistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SwopHistoryTableViewCell", for: indexPath as IndexPath) as! SwopHistoryTableViewCell
            cell.updateCell(swopRequest: self.pastSwops[indexPath.row], delegate: self)
            cell.selectionStyle = .none
            return cell
        }
        
        let cell: SwoppedItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SwoppedItemTableViewCell", for: indexPath as IndexPath) as! SwoppedItemTableViewCell
        
        if(!self.isDSSwop){
            cell.selectionStyle = .none
            cell.updateCell(item: self.items[indexPath.row])
        }
        else{
            cell.updateCell(item: self.items[indexPath.row], selected: self.isItemAlreadySelected(item: self.items[indexPath.row]))
        }
        if(self.isItemAlreadySelected(item: self.items[indexPath.row])){
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(tableView == self.swopHistoryTableView || tableView == self.loggedInUserSwopHistoryTableView){
            return self.pastSwops.count
        }
        return self.items.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 95.0
    }
    
    func getItemsByCategoryAndUserId(){
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network, and try again", vc: self)
            return
        }
        let url = Constants.GET_ITEMS_BY_CATEGORY_AND_USER_ID
        let params = [Constants.KEY_USER_ID :  Utils.getLoggedInUserId(), Constants.KEY_CATEGORY: self.selectedCategory?.name!]
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: url, params: params as [String : AnyObject]?, httpMethod: Constants.HTTP_METHOD_POST) { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            let respCode = (resp?[Constants.KEY_RESPONSE_CODE] as! Int)
            print("Response : \(resp)")
            if(respCode == 1){
                self.items = ModelFactory.createItemsList(dict: resp!)
                self.swoppedItemsTableView.reloadData()
            }
        }
    }
    func getSelectedItemIndex(item : Item) -> Int{
        var i = 0
        for itm in self.selectedItems{
            if(itm.itemId! == item.itemId!){
                return i
            }
            i += 1
        }
        return i
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if(self.isDSSwop){
            if(!self.isItemAlreadySelected(item: self.items[indexPath.row])){
                self.selectedItems.append(self.items[indexPath.row])
            }
            else{
                self.selectedItems.remove(at: getSelectedItemIndex(item: self.items[indexPath.row]))
            }
            tableView.reloadData()
        }
    }
    
    func getItemsByUserId(){
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network, and try again", vc: self)
            return
        }
        let url = Constants.GET_ITEM_BY_USER_ID_URL
        let params = [Constants.KEY_USER_ID :  self.userId!]
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: url, params: params as [String : AnyObject]?, httpMethod: Constants.HTTP_METHOD_POST) { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            let respCode = (resp?[Constants.KEY_RESPONSE_CODE] as! Int)
            print("Response : \(resp)")
            if(respCode == 1){
                self.items = ModelFactory.createItemsList(dict: resp!)
                self.swoppedItemsTableView.reloadData()
            }
        }
    }
    
    @IBAction func dsSwop(_ sender: Any) {
        if(self.selectedItems.count > 0){
        let sivc = SwopItemsViewController(nibName: "SwopItemsViewController", bundle: nil, receivedItems: self.selectedItems)
        self.present(sivc, animated: false, completion: nil)
        }
        else{
            Utils.showAlert(title: "SwopIt", msg: "Please select at least 1 item before proceeding", vc: self)
        }
    }
    @IBAction func showCoinsView(_ sender: Any) {
        if(buyCoinsVIewHeightConstraint.constant == 0){
            self.buyCoinsParentVieHeightConstraint.constant = 160
            self.buyCoinsVIewHeightConstraint.constant = 120
            
        }
        else{
            self.buyCoinsParentVieHeightConstraint.constant = 40
            self.buyCoinsVIewHeightConstraint.constant = 0
        }
    }
    @IBAction func buy5Coins(_ sender: Any) {
        if(self.productsAvailable){
            ProfileViewController.iaHelper?.buy(index: 0)
        }
        else{
            
        }
    }
    @IBAction func buy50Coins(_ sender: Any) {
        if(self.productsAvailable){
            ProfileViewController.iaHelper?.buy(index: 1)
        }
        else{
            
        }
    }
    @IBAction func buy200Coins(_ sender: Any) {
        if(self.productsAvailable){
            ProfileViewController.iaHelper?.buy(index: 2)
        }
        else{
            
        }
    }
    static var iaHelper: IAPHelper?
    func getIAProducts(){
       
        ProfileViewController.iaHelper?.requestProductInfo()
    }
    func onProductsAvailable(){
        self.productsAvailable = true
    }
    func onProductsNotAvailable(){
        
    }
    func getSwopFriends(){
        let params = ["UserId":self.userId]
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: Constants.GET_CHAT_LIST_BY_USER_ID, params: params as [String : AnyObject]?, httpMethod: "POST") { (response) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if(response?[Constants.KEY_RESPONSE_CODE] as! Int == 1){
                let users = response?[Constants.KEY_RESPONSE] as! [[String: AnyObject]]
                self.swopFriends = [User]()
                for usr in users{
                    self.swopFriends.append(User(dict: usr))
                }
            }
            else{
                self.swopFriends = [User]()
            }
            print("Swop Friends Count \(self.swopFriends.count)")
            self.swopFriendsCollectionView.reloadData()
        }
    }
    

    
    func goToProfile(userId: String){
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil, userId: userId)
        self.present(profileVC, animated: false, completion: nil)
    }
    
    func getPastSwopRequests(){
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network, and try again", vc: self)
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: false)
        let params = [Constants.KEY_USER_ID : self.userId != nil ? self.userId : Utils.getLoggedInUserId()]
        Utils.httpCall(url: Constants.GET_SWOP_HISTORY, params: params as [String : AnyObject]?, httpMethod: "POST") { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if(resp![Constants.KEY_RESPONSE_CODE] as! Int == 1){
                let response = resp!["Response"]
                self.pastSwops = [SwopRequest]()
                for elem in response as! [[String: AnyObject]]{
                    self.pastSwops.append(SwopRequest(dict: elem))
                }
            }
            if(self.userId == nil){
                self.loggedInUserSwopHistoryTableView.reloadData()
            }
            else{
                self.swopHistoryTableView.reloadData()
            }
            print("History Count \(self.pastSwops.count)")
            
        }
    }
    
    func rejectRequest(sr: SwopRequest){
    }
    func acceptRequest(sr: SwopRequest){
    }
    func onTransactionFailed(){
        Utils.showAlert(title: "SwopIt", msg: "Cannot add coins. Transaction failed", vc: self)
    }
    func onTransactionPassed(){
        Utils.showAlert(title: "SwopIt", msg: "Coins Added.", vc: self)
    }
}
