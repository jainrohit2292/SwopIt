//
//  ItemDetailsViewController.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 3/16/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import GoogleMaps
import MBProgressHUD


class ItemDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var dsSwopBtn: UIButton!

    @IBOutlet weak var coinSwopBtn: UIButton!
    @IBOutlet weak var swopItBtn: UIButton!
    @IBOutlet weak var profileImageV: UIImageView!
    @IBOutlet weak var itemImagePlaceholderImageV: UIImageView!
    @IBOutlet weak var itemImageCollectionView: UICollectionView!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var postedDateLbl: UILabel!
    @IBOutlet weak var postedByLbl: UILabel!
    @IBOutlet weak var locationMapView: UIView!
    @IBOutlet weak var itemDetailLbl: UILabel!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemNameTitleLbl: UILabel!
    var item: Item?
    
    var isSwopRequest = false
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, item: Item) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.item = item
    }
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, item: Item, isSwopRequest:Bool) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.item = item
        self.isSwopRequest = isSwopRequest
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if(self.isSwopRequest){
            self.dsSwopBtn.isHidden = true
            self.swopItBtn.isHidden = true
            self.coinSwopBtn.isHidden = true
        }
        else{
            self.dsSwopBtn.isHidden = false
            self.swopItBtn.isHidden = false
            self.coinSwopBtn.isHidden = false
        }
        let collCellNib =  UINib(nibName: "ItemDetailImageCollectionViewCell", bundle: nil)
        self.itemImageCollectionView.register(collCellNib, forCellWithReuseIdentifier: "ItemDetailImageCollectionViewCell")
        self.itemImageCollectionView.delegate = self
        self.itemImageCollectionView.dataSource = self
        self.itemNameLbl.text = self.item?.name!
        self.itemDetailLbl.text = self.item?.details!
        self.itemNameTitleLbl.text = self.item?.name!
        let dist = self.item?.distance
        if(dist != nil){
            self.distanceLbl.text = String(Int(Float((dist!))!)) + "km"
        }
        self.postedByLbl.text = (item?.user?.name!)! + " posted"
        let postedDate = item?.postDate!
        let dfm = DateFormatter()
        dfm.dateFormat = "MM/dd/yyyy HH:mm:ss"
        let date = dfm.date(from: postedDate!)
        let month = Utils.getMonthNameForNumber(num:Calendar.current.component(.month, from:date!))
        let day = Calendar.current.component(.day, from: date!)
        let year = Calendar.current.component(.year, from: date!)
        let dateStr = String(day) + " " + month + ", " + String(year)
        self.postedDateLbl.text = dateStr
        self.profileImageV.layer.cornerRadius = self.profileImageV.frame.width/2
        self.profileImageV.clipsToBounds = true
        self.profileImageV.sd_setImage(with: URL(string: (item?.user?.profilePictureUrl!)!), placeholderImage: UIImage(named:"profile_placeholder"))
        self.updateMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if((self.item?.urls.count)! <= 0){
            self.itemImageCollectionView.isHidden = true
        }
        else{
            self.itemImageCollectionView.isHidden = false
        }
        return (self.item?.urls.count)!
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemDetailImageCollectionViewCell", for: indexPath) as! ItemDetailImageCollectionViewCell
        cell.updateCell(imageUrl: (self.item?.urls[indexPath.row])!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        return  CGSize(width: UIScreen.main.bounds.width , height: 210)
    }

   
    
    func updateMap(){
        let lat = CLLocationDegrees(Float((item?.user?.latitude!)!)!)
        let long = CLLocationDegrees(Float((item?.user?.longitude!)!)!)
        let camera = GMSCameraPosition.camera(withLatitude: lat,
                                              longitude: long,
                                              zoom: 14)
        let mapView = GMSMapView.map(withFrame: CGRect(x:0.0, y:0.0, width: self.locationMapView.frame.width, height: self.locationMapView.frame.height), camera: camera)
        print("Map View Width : \(mapView.frame.width)")
        print("Map View Height : \(mapView.frame.height)")
        
        let marker = GMSMarker()
        marker.position = camera.target
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        self.locationMapView.addSubview(mapView)
        
    }
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: false) {
            
        }
    }
    var visibleIndexPath : IndexPath = IndexPath(row: 0, section: 0)
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)  {
        for cell in self.itemImageCollectionView.visibleCells  as [UICollectionViewCell]    {
            let indexPath = self.itemImageCollectionView.indexPath(for: cell as UICollectionViewCell)
            self.visibleIndexPath = indexPath!
        }
        print("Visible Index Path : \(visibleIndexPath.row)")
    }
    
    @IBAction func goToNext(_ sender: Any) {
        print("Going to next so Visible Index Path : \(visibleIndexPath.row)")
        if((visibleIndexPath.row + 1) < (self.item?.urls.count)!){
            let nextIndexPath = IndexPath(row: self.visibleIndexPath.row + 1, section: 0)
            self.itemImageCollectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
            visibleIndexPath = nextIndexPath
        }
    }
    @IBAction func goToPrev(_ sender: Any) {
        if((visibleIndexPath.row) > 0){
            let prevIndexPath = IndexPath(row: self.visibleIndexPath.row - 1, section: 0)
            self.itemImageCollectionView.scrollToItem(at: prevIndexPath, at: .centeredHorizontally, animated: true)
            visibleIndexPath = prevIndexPath
        }
    }
    @IBAction func sendSwopRequest(_ sender: Any) {
        if(!Utils.isUserLoggedin()){
            let loginVC = LoginViewController()
            self.present(loginVC, animated: false, completion: nil)
            return
        }
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil, userId: (self.item?.user?.userId)!, isDSSwop: true)
        self.present(profileVC, animated: false, completion: nil)
    }
    @IBAction func goToProfile(_ sender: Any) {
        let profVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil, userId: (self.item?.user?.userId)!)
        self.present(profVC, animated: false) { 
            
        }
    }
    @IBAction func swopIt(_ sender: Any) {
        if(!Utils.isUserLoggedin()){
            let loginVC = LoginViewController()
            self.present(loginVC, animated: false, completion: nil)
            return
        }
        let sitvc = SwopItemsViewController(nibName: "SwopItemsViewController", bundle: nil, receivedItem: self.item!)
        self.present(sitvc, animated: false, completion: nil)
    }
    @IBAction func coinSwop(_ sender: Any) {
        if(!Utils.isUserLoggedin()){
            let loginVC = LoginViewController()
            self.present(loginVC, animated: false, completion: nil)
            return
        }
        let alert = UIAlertController(title: "SwopIt", message: "Please enter number of coins you want to swop with", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Num Of Coins"
            textfield.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
            let txtField = alert.textFields?[0]
            self.sendCoinSwopRequest(item: self.item!, coins: (txtField?.text)!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
            
        }))
        self.present(alert, animated: false, completion: nil)

    }
    
    func sendCoinSwopRequest(item: Item, coins: String){
        if(!Utils.isUserLoggedin()){
            self.present(LoginViewController(), animated: false, completion: {
                
            })
            return
        }
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network, and try again", vc: self)
            return
        }
        let itemId = item.itemId!
        let receiverId = self.item?.user?.userId!
       
        let swopType = "Coin"
        
        let params = ["Sender": Utils.getLoggedInUserId(), "Reciever": receiverId, "SwopType":swopType, "RecieverItems": itemId, "Coins": coins]
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: Constants.SEND_SWOP_REQUEST, params: params as [String : AnyObject]?, httpMethod: "POST") { (response) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if((response?[Constants.KEY_RESPONSE_CODE] as! Int) == 1){
                Utils.showAlertAndDismiss(title: "SwopIt", msg: "Request Sent Successfully!!", vc: self)
            }
            else{
                Utils.showAlert(title: "SwopIt", msg: "Unable to send request. Please try again.", vc: self)
            }
            
        }
    }

}
