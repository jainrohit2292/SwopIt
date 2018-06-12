//
//  MainTabsViewController.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 3/7/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol TopBarItemsProtocol{
    func toggleCategoryVisibilty()
    func searchItemBy(text: String)
    func refreshAfterSearch()
    func refreshAfterCategoriesClosed()
    
}
protocol SwopItTabBarHandlerProtocol {
    func presentVC(vc: UIViewController)
}

class MainTabsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwopItTabBarHandlerProtocol, UITabBarControllerDelegate, UISearchBarDelegate {
    @IBOutlet weak var showCategoriesButton: UIButton!

    @IBOutlet weak var leftMenuTopBtn: UIButton!
    @IBOutlet weak var mainUserNameLbl: UILabel!
    @IBOutlet weak var mainTopBarView: UIView!
    @IBOutlet weak var tabsView: UIView!
    @IBOutlet weak var menuProfileImageView: UIImageView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loginSignupViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var signInSingUpView: UIView!
    @IBOutlet weak var addItemsView: UIView!
    @IBOutlet weak var addItemsBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var menuViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImgV: UIImageView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var mainTabsView: UIView!
    

    
    
    var delegates: [TopBarItemsProtocol] = [TopBarItemsProtocol]()
    
    var isMenuVisible = false
    var cats : [Category] = [Category]()
    let categories = [[UIImage(named:"fashion_inactive"), "Fashion"], [UIImage(named:"electronics_inactive"), "Electronics"],[UIImage(named:"cosmetics_inactive"), "Cosmetics"], [UIImage(named:"furniture_inactive"), "Furniture"]]
    let catImagesDict : [String : UIImage?] = ["Fashion" : UIImage(named:"fashion_inactive"), "Electronics" : UIImage(named:"electronics_inactive"), "Book & Art" : UIImage(named:"bookandart_inactive")]
    let selectedCatImagesDict : [String : UIImage?] = ["Fashion" : UIImage(named:"fashion_active"), "Electronics" : UIImage(named:"electronics_active"), "Book & Art" : UIImage(named:"bookandart_active")]
    
    let subCatImagesDict = ["Accessories" : UIImage(named:"accessories_inactive"), "Dress" : UIImage(named:"dres_inactive"), "Shoes" : UIImage(named:"shoe_inactive"), "Mobile" : UIImage(named:"mobile_inactive"), "iPad & Laptops" : UIImage(named:"laptop_inactive"), "Electronics" : UIImage(named:"electronics_inactive"), "Art" : UIImage(named:"art_inactive"), "Books" : UIImage(named:"bookandart_inactive"), "Films" : UIImage(named:"films_inactive")]
    let selectedSubCatImages = ["Accessories" : UIImage(named:"accessories_active"), "Dress" : UIImage(named:"dres_active"), "Shoes" : UIImage(named:"shoe_active"), "Mobile" : UIImage(named:"mobile_active"), "iPad & Laptops" : UIImage(named:"laptop_active"), "Electronics" : UIImage(named:"electronics_active"), "Art" : UIImage(named:"art_active"), "Books" : UIImage(named:"bookandart_active"), "Films" : UIImage(named:"films_active")]
//    [UIImage(named:"profile_icon"), "Profile"],
    let menuItems = [  [UIImage(named:"settings_icon"), "Settings"],
                       [UIImage(named:"ic_mail"), "Inbox"], [UIImage(named:"help_icon"), "Help"], [UIImage(named:"help_icon"), "Contact Us"], [UIImage(named:"become_swapper_icon"), "Become a swopper"], [UIImage(named:"become_swapper_icon"), "My Items"], [UIImage(named:"settings_icon"), "LogOut"]]
    let menuItemsWithoutLoggedInUser = [[UIImage(named:"settings_icon"), "Settings"] , [UIImage(named:"help_icon"), "Help"],[UIImage(named:"help_icon"), "Contact Us"]]
    
    var tab: UITabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAllCategories()
        self.searchView.isHidden = true
        self.mainUserNameLbl.text = Utils.getLoggedInUserName()
        searchBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateMenu(_:)), name: NSNotification.Name(rawValue: "updateMenu"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(Utils.isUserLoggedin()){
            self.signInSingUpView.isHidden = true
            self.loginSignupViewHeightConstraint.constant = 0
        }
        else{
            self.signInSingUpView.isHidden = false
            self.loginSignupViewHeightConstraint.constant = 25
        }
        self.initMenu()
    }
    
    func updateMenu(_ notification: NSNotification) {
        self.menuTableView.reloadData()
    }
    
    func initMenu(){
        let cellnib = UINib(nibName: "MenuTableViewCell", bundle: nil)
        self.menuTableView.register(cellnib, forCellReuseIdentifier: "MenuTableViewCell")
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
        self.nameLbl.text = Utils.getLoggedInUserName()
        self.profileImgV.layer.cornerRadius = self.profileImgV.frame.width/2
        self.profileImgV.clipsToBounds = true
        if(Utils.isUserLoggedin()){
        let profUrl = Utils.getLoggedInUserProfilePictureUrl()
        self.profileImgV.sd_setImage(with: URL(string: Constants.GET_PROFILE_PIC_URL + profUrl), placeholderImage: UIImage(named:"profile_placeholder"))
        }
        self.menuTableView.reloadData()
    }
    
    func initTabViews(){
        self.tab = UITabBarController()
        self.tab?.view.frame = CGRect(x:0.0, y:0.0, width: self.view.frame.width, height: self.view.frame.height-70)
        let itemsVC = ItemsViewController(nibName: "ItemsViewController", bundle: nil, cats: self.cats, catImagesDict: self.catImagesDict,selectedCatImagesDict: self.selectedCatImagesDict ,subCatImagesDict: self.subCatImagesDict, selectedSubCatImagesDict: self.selectedSubCatImages, delegate: self)
        self.delegates.append(itemsVC)
        let dealsVC = MyDealsViewController()
        let savedVC = SavedViewController()
        let chatVC = ChatListViewController(nibName: "ChatListViewController", bundle: nil, delegate: self)
        let navigationVC1 = UINavigationController()
        navigationVC1.navigationBar.isHidden = true
        let navigationVC2 = UINavigationController()
        navigationVC2.navigationBar.isHidden = true
        let navigationVC3 = UINavigationController()
        navigationVC3.navigationBar.isHidden = true
        let navigationVC4 = UINavigationController()
        navigationVC4.navigationBar.isHidden = true
        navigationVC1.pushViewController(dealsVC, animated: false)
        navigationVC2.pushViewController(itemsVC, animated: false)
        navigationVC3.pushViewController(savedVC, animated: false)
        navigationVC4.pushViewController(chatVC, animated: false)
//        let vcsArray = [navigationVC1, navigationVC2, navigationVC3, navigationVC4]
        let vcsArray = [navigationVC2, navigationVC4]
        let myDealsTabBarItem:UITabBarItem = UITabBarItem(title: "", image: Utils.imageWithImage(image: UIImage(named: "my_deals_inactive")!, scaledToSize: CGSize(width: UIScreen.main.bounds.width/4, height: 49)).withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage:Utils.imageWithImage(image: UIImage(named: "my_deals_active")!, scaledToSize: CGSize(width: UIScreen.main.bounds.width/4, height: 49)).withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        
        let swopListTabBarItem:UITabBarItem = UITabBarItem(title: "", image: Utils.imageWithImage(image: UIImage(named: "swop-list-inactive-tabs")!, scaledToSize: CGSize(width: UIScreen.main.bounds.width/2, height: 49)).withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage:Utils.imageWithImage(image: UIImage(named: "swop-list-active-tabs")!, scaledToSize: CGSize(width: UIScreen.main.bounds.width/2, height: 49)).withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        
        let savedTabBarItem:UITabBarItem = UITabBarItem(title: "", image: Utils.imageWithImage(image: UIImage(named: "saved_inactive")!, scaledToSize: CGSize(width: UIScreen.main.bounds.width/4, height: 49)).withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage:Utils.imageWithImage(image: UIImage(named: "saved_active")!, scaledToSize: CGSize(width: UIScreen.main.bounds.width/4, height: 49)).withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        
        let chatTabBarItem:UITabBarItem = UITabBarItem(title: "", image: Utils.imageWithImage(image: UIImage(named: "chat-inactive-tabs")!, scaledToSize: CGSize(width: UIScreen.main.bounds.width/2, height: 49)).withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage:Utils.imageWithImage(image: UIImage(named: "chat-active-tabs")!, scaledToSize: CGSize(width: UIScreen.main.bounds.width/2, height: 49)).withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        
        myDealsTabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        swopListTabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        savedTabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        chatTabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        dealsVC.tabBarItem = myDealsTabBarItem
        savedVC.tabBarItem = savedTabBarItem
        chatVC.tabBarItem = chatTabBarItem
        itemsVC.tabBarItem = swopListTabBarItem
        
        self.tab?.setViewControllers(vcsArray, animated: false)
        self.tab?.selectedIndex = 0
        self.tab?.delegate = self
        self.tabsView.addSubview((self.tab?.view)!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(_tableView: UITableView) -> Int{
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell: MenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath as IndexPath) as! MenuTableViewCell
        if(Utils.isUserLoggedin()){
            cell.updateCell(image: self.menuItems[indexPath.row][0] as? UIImage, title: self.menuItems[indexPath.row][1] as! String)
        }
        else{
            cell.updateCell(image: self.menuItemsWithoutLoggedInUser[indexPath.row][0] as? UIImage, title: self.menuItemsWithoutLoggedInUser[indexPath.row][1] as! String)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(Utils.isUserLoggedin()){
            return self.menuItems.count
        }
        else{
            return self.menuItemsWithoutLoggedInUser.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 52
    }
    
    @IBAction func onMenuButtonPressed(_ sender: Any) {
        if(self.isMenuVisible){
            hideMenu()
        }else{
            showMenu()
        }
        self.isMenuVisible = !self.isMenuVisible
    }
    func hideMenu(){
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [.repeat, .curveEaseOut, .autoreverse], animations: {
            self.menuViewLeadingConstraint.constant = -self.menuView.frame.width
        }, completion: {(completed) in
            self.titleLbl.isHidden = false
            self.addItemsView.isHidden = false
            self.searchButton.isHidden = false
            self.tab?.tabBar.isHidden = false
            self.showCategoriesButton.isHidden = false
            self.tabsView.isUserInteractionEnabled = true
        })
    }
    func showMenu(){
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [.repeat, .curveEaseOut, .autoreverse], animations: {
            self.menuViewLeadingConstraint.constant = 0
        }, completion: {(completed) in
            self.titleLbl.isHidden = true
            self.addItemsView.isHidden = true
            self.searchButton.isHidden = true
            self.tab?.tabBar.isHidden = true
            self.showCategoriesButton.isHidden = true
            self.tabsView.isUserInteractionEnabled = false
        })

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        switch indexPath.row {
        case 0:
//            if(Utils.isUserLoggedin()){
//            self.present(ProfileViewController(), animated: false, completion: {
//                
//            })
//            }
//            else{
                self.present(SettingsViewController(), animated: false, completion: {
                    
                })
//            }
            break
        case 1:
            if(Utils.isUserLoggedin()){
                hideMenu()
                let selectedVC =  self.tab!.selectedViewController as! UINavigationController
                print("Selected VC : \(selectedVC)")
                self.mainTopBarView.isHidden = true
                
                let chatAndReqVC = ChatAndRequestsViewController(nibName: "ChatAndRequestsViewController", bundle: nil, delegate: self)
              selectedVC.pushViewController(chatAndReqVC, animated: false)
            }
//            self.present(SettingsViewController(), animated: false, completion: {
//                
//            })
            else{
                let loginVC = LoginViewController()
                self.present(loginVC, animated: false, completion: nil)
            }
            break
        case 2:
            if(Utils.isUserLoggedin()){
                let helpVC = HelpViewController()
                self.present(helpVC, animated: false, completion: nil)
            }
            else{
                let contactUsVC = ContactUsViewController()
                self.present(contactUsVC, animated: false, completion: nil)
            }
            break
        case 3:
            if(Utils.isUserLoggedin()){
                let contactUsVC = ContactUsViewController()
                self.present(contactUsVC, animated: false, completion: nil)
            }
            else{

            }
            break
        case 4:
            if(Utils.isUserLoggedin()){
                let becomASwopperVC = BecomeASwopperViewController()
                self.present(becomASwopperVC, animated: false, completion: nil)
            }
            break
            
        case 5:
            if(Utils.isUserLoggedin()){
                let myDealsVC = MyDealsViewController()
                self.present(myDealsVC, animated: false, completion: nil)
            }
            break
        case 6:
            if(Utils.isUserLoggedin()){
                let defaults = UserDefaults.standard
                let alert = UIAlertController(title: "SwopIt", message: "Are you sure to log out?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
                    //        defaults.set(nil, forKey:"userId")
                    defaults.removeObject(forKey: Constants.KEY_USER_ID)
                    defaults.removeObject(forKey: Constants.KEY_USERNAME)
                    defaults.removeObject(forKey: Constants.KEY_NAME)
                    defaults.removeObject(forKey: Constants.KEY_PROFILE_PICTURE)
                    self.signInSingUpView.isHidden = false
                    self.loginSignupViewHeightConstraint.constant = 25
                
                    self.initMenu()
                    for delegate in self.delegates{
                        delegate.refreshAfterSearch()
                    }
                    
                }))
                alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
                    print("Handle Ok logic here")
                }))
                self.present(alert, animated: true, completion: nil)
            }
            break
        default:
            Utils.showAlert(title: "SwopIt", msg: "Coming Soon!", vc: self)
            break
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
            }
            self.initTabViews()
            
        }
    }
    @IBAction func addItem(_ sender: Any) {
        if(Utils.isUserLoggedin()){
        let addItemVC = AddItemsViewController(nibName: "AddItemsViewController", bundle: nil, cats: self.cats, catImagesDict: self.catImagesDict, subCatImagesDict: self.subCatImagesDict, selectedCatImagesDict: self.selectedCatImagesDict, selectedSubCatImagesDict: self.selectedSubCatImages)
        self.present(addItemVC, animated: false) {
            
        }
        }
        else{
            self.present(LoginViewController(), animated: false, completion: nil)
        }
    }
    @IBAction func showCategories(_ sender: Any) {
        for delegate in self.delegates{
            delegate.toggleCategoryVisibilty()
            
        }
    }
    @IBAction func signInOrSignUp(_ sender: Any) {
        self.present(LoginViewController(), animated: false, completion: nil)
    }
    @IBAction func hideShowSearchBar(_ sender: Any) {
        self.searchView.isHidden = !self.searchView.isHidden
        if(self.searchView.isHidden){
            for delegate in self.delegates{
                delegate.refreshAfterSearch()
                self.searchBar.resignFirstResponder()
            }
        }
        else{
            self.searchBar.becomeFirstResponder()
        }
    }
    func presentVC(vc: UIViewController){
        
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func closeMenu(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [.repeat, .curveEaseOut, .autoreverse], animations: {
            self.menuViewLeadingConstraint.constant = -self.menuView.frame.width
        }, completion: {(completed) in
            self.titleLbl.isHidden = false
            self.addItemsView.isHidden = false
            self.searchButton.isHidden = false
            self.tab?.tabBar.isHidden = false
            self.showCategoriesButton.isHidden = false
            self.tabsView.isUserInteractionEnabled = true
        })

    }
    @IBAction func goToProfileVC(_ sender: Any) {
        if(Utils.isUserLoggedin()){
            self.present(ProfileViewController(), animated: false, completion: nil)
        }
    }
    @IBAction func search(_ sender: Any) {
        for delegate in self.delegates{
            delegate.searchItemBy(text: self.searchBar.text!)
            self.searchBar.resignFirstResponder()
        }
    }
    @IBAction func goBack(_ sender: Any) {
        let selectedVC = self.tab?.selectedViewController as! UINavigationController
        selectedVC.popViewController(animated: false)
        self.mainTopBarView.isHidden = false
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
        if(tabBarController.selectedIndex == 1){
            self.leftMenuTopBtn.isHidden = true
            self.searchButton.isHidden = true
            self.searchView.isHidden = true
            self.showCategoriesButton.isHidden = true
        }
        else{
            self.leftMenuTopBtn.isHidden = false
            self.searchButton.isHidden = false
            self.showCategoriesButton.isHidden = false
        }
    }
    func presentChatVCFromNotifications(userId: String, userId2: String, receiver: String){
        let chatViewController = ChatViewController(nibName: "ChatViewController", bundle: nil, userId: userId, userId2: userId2, receiverName: receiver)
        self.present(chatViewController, animated: false, completion: nil)
            
    }
    func goToInboxFromNotifications(){
        let selectedVC =  self.tab!.selectedViewController as! UINavigationController
        print("Selected VC : \(selectedVC)")
        self.mainTopBarView.isHidden = true
        
        let chatAndReqVC = ChatAndRequestsViewController(nibName: "ChatAndRequestsViewController", bundle: nil, delegate: self)
        selectedVC.pushViewController(chatAndReqVC, animated: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        for delegate in self.delegates{
            if(searchText.isEmpty){
                delegate.refreshAfterSearch()
            }else{
                delegate.searchItemBy(text: searchText)
            }
        }
    }
}
