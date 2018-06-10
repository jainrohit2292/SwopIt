//
//  AddItemsViewController.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 3/4/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreImage
import CoreGraphics
import PhotosUI
import Alamofire

class AddItemsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var itemsTitleView: UIView!
    
    @IBOutlet weak var scrollInnerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollInnerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var removeImg5: UIButton!
    @IBOutlet weak var removeImg4: UIButton!
    @IBOutlet weak var removeImg3: UIButton!
    @IBOutlet weak var removeImg2: UIButton!
    @IBOutlet weak var removeImg1: UIButton!
    @IBOutlet weak var itemsDescriptionView: UIView!
    @IBOutlet weak var itemTitle: EditProfileTextField!
    
    @IBOutlet weak var itemConditionSwitch: UISwitch!
    @IBOutlet weak var itemDescription: EditProfileTextField!
    @IBOutlet weak var itemFirstImageV: UIImageView!
    
    @IBOutlet weak var itemSecondImageV: UIImageView!
    
    @IBOutlet weak var itemThirdImageV: UIImageView!
    
    @IBOutlet weak var fourthImageV: UIImageView!
    
    @IBOutlet weak var itemFifthImageV: UIImageView!
    @IBOutlet weak var moreThan2YearsBtn: UIButton!
    @IBOutlet weak var lessThan2YearsBtn: UIButton!
    @IBOutlet weak var newBtn: UIButton!
    
    var addedItemId: String?
    var currentUpdatingImageNumber = 0
    var cats : [Category]?
    var selectedCategory:Category?
    var selectedSubCategory:SubCategory?
    @IBOutlet weak var subcategoriesCollectionView: UICollectionView!
    var itemImages = [UIImage]()
    var catImagesDict : [String: UIImage?]?
    var subCatImagesDict : [String : UIImage?]?
    var selectedSubCatImagesDict: [String: UIImage?]?
    var selectedCatImagesDict: [String: UIImage?]?
    var itemCondition: String?
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
        let categories = [[UIImage(named:"fashion_inactive"), "Fashion"], [UIImage(named:"electronics_inactive"), "Electronics"],[UIImage(named:"cosmetics_inactive"), "Cosmetics"], [UIImage(named:"furniture_inactive"), "Furniture"]]
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, cats: [Category], catImagesDict: [String: UIImage?], subCatImagesDict: [String: UIImage?]? ,selectedCatImagesDict: [String: UIImage?]?, selectedSubCatImagesDict: [String: UIImage?]?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.cats = cats
        self.catImagesDict =  catImagesDict
        self.subCatImagesDict = subCatImagesDict
        self.selectedCatImagesDict = selectedCatImagesDict
        self.selectedSubCatImagesDict = selectedSubCatImagesDict
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let collCellNib =  UINib(nibName: "CategoriesCollectionViewCell", bundle: nil)
        self.categoriesCollectionView.register(collCellNib, forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
        self.subcategoriesCollectionView.register(collCellNib, forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
        self.subcategoriesCollectionView.delegate = self
        self.subcategoriesCollectionView.dataSource = self
        self.categoriesCollectionView.delegate = self
        self.categoriesCollectionView.dataSource = self
        self.addPlaceholderPadding()
        let tapGestureRecognizer1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddItemsViewController.onViewTapped))
        let tapGestureRecognizer2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddItemsViewController.onViewTapped))

        self.itemsTitleView.addGestureRecognizer(tapGestureRecognizer1)
         self.itemsDescriptionView.addGestureRecognizer(tapGestureRecognizer2)
        
        moreThan2YearsBtn.layer.borderColor = UIColor.lightGray.cgColor
        moreThan2YearsBtn.layer.borderWidth = 2
        moreThan2YearsBtn.layer.cornerRadius = 9
        lessThan2YearsBtn.layer.borderColor = UIColor.lightGray.cgColor
        lessThan2YearsBtn.layer.borderWidth = 2
        lessThan2YearsBtn.layer.cornerRadius = 9
        newBtn.layer.borderColor = UIColor.lightGray.cgColor
        newBtn.layer.borderWidth = 2
        newBtn.layer.cornerRadius = 9
    }
    func onViewTapped(){
        self.itemTitle.resignFirstResponder()
        self.itemDescription.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        else if(collectionView == self.subcategoriesCollectionView){
            if(self.selectedCategory != nil){
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as! CategoriesCollectionViewCell
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



    
    func addItem(itemName: String, itemDetails: String, itemCondition: String, categoryId: String, userId: String, images:[UIImage]){
        if(!Reachability.isConnectedToNetwork()){
            Utils.showAlert(title: "SwopIt", msg: "Pease connect to network.", vc: self)
            return
        }
        if(itemName.characters.count > 15){
            Utils.showAlert(title: "SwopIt", msg: "Item name cannot be greater than 15 characters.", vc: self)
            return
        }
        let params = [Constants.KEY_ITEM_NAME: itemName, Constants.KEY_ITEM_DETAILS: itemDetails, Constants.KEY_ITEM_CONDITION: itemCondition, Constants.KEY_CATEGORY_ID: categoryId, Constants.KEY_USER_ID: userId]
        MBProgressHUD.showAdded(to: self.view, animated: false)
        Utils.httpCall(url: Constants.ADD_ITEM_URL, params: params as [String : AnyObject]?, httpMethod: Constants.HTTP_METHOD_POST) { (resp) in
            MBProgressHUD.hide(for: self.view, animated: false)
            if(resp != nil){
                if((resp?[Constants.KEY_RESPONSE_CODE] as! Int) == 1){
                    self.addedItemId = resp?[Constants.KEY_RESPONSE] as! String
                    self.uploadImg(images: images)
                }
                else{
                    Utils.showAlert(title: "SwopIt", msg: "Couldn't add Item. Please try agaian.", vc: self)
                }
            }
            else{
                Utils.showAlert(title: "SwopIt", msg: "Couldn't add Item. Please try agaian.", vc: self)
            }
            self.dismiss(animated: false) {
                
            }
        }
    }
    
    func uploadImg(images:[UIImage]){
        let urlStr = Constants.UPLOAD_ITEM_IMAGE
        for i in 0...images.count - 1{
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                let img = Utils.imageWithImage(image: images[i], scaledToSize: CGSize(width:60, height:60))
                let imgData = UIImageJPEGRepresentation(img, 0.9)
                multipartFormData.append(imgData!, withName: "journalImg", fileName: "\(i+1).jpg", mimeType: "image/jpg")
                multipartFormData.append((self.addedItemId?.data(using:.utf8)!)!, withName: "ItemId")
                multipartFormData.append("\(i+1)".data(using: .utf8)!, withName: "ImageNumber")
            }, to:urlStr)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print("Response : \(response)")
                    }
                case .failure( _):
                    print("Error")
                }
            }
        }
        
        
        MBProgressHUD.showAdded(to: self.view, animated: false)
    }
    
    @IBAction func goBack(_ sender: Any) {
       
        
        self.dismiss(animated: false) { 
            
        }
    }
    
    @IBAction func addItem(_ sender: Any) {
        var images = [UIImage]()
        if let img1 = self.itemFirstImageV.image {
          //  Utils.showAlert(title: "SwopIt", msg: "Please select first image", vc: self)
          //  return
            images.append(img1)
        }
        if let img2 = self.itemSecondImageV.image {
          //  Utils.showAlert(title: "SwopIt", msg: "Please select second image", vc: self)
          //  return
            images.append(img2)
        }
        if let img3 = self.itemThirdImageV.image {
          //  Utils.showAlert(title: "SwopIt", msg: "Please select third image", vc: self)
          //  return
            images.append(img3)
        }
        if let img4 = self.fourthImageV.image {
           // Utils.showAlert(title: "SwopIt", msg: "Please select fourth image", vc: self)
           // return
            images.append(img4)
        }
        if let img5 = self.itemFifthImageV.image {
            //Utils.showAlert(title: "SwopIt", msg: "Please select fifth image", vc: self)
            //return
            images.append(img5)

        }
        if(images.count <= 0){
            Utils.showAlert(title: "SwopIt", msg: "Please atleast select one image", vc: self)
            return
        }
        guard let itmNm = self.itemTitle.text else {
            Utils.showAlert(title: "SwopIt", msg: "Please enter Item Name", vc: self)
            return
        }
        if(itmNm.count <= 0){
            Utils.showAlert(title: "SwopIt", msg: "Please enter Item Name", vc: self)
            return
        }
        guard let itmDesc = self.itemDescription.text else {
            Utils.showAlert(title: "SwopIt", msg: "Please enter Item Description", vc: self)
            return
        }
        if(itmDesc.count <= 0){
            Utils.showAlert(title: "SwopIt", msg: "Please enter Item Description", vc: self)
            return
        }
        guard self.selectedSubCategory != nil else {
            Utils.showAlert(title: "SwopIt", msg: "Please select a subcategory", vc: self)
            return
        }
        
        guard let itmCondition = self.itemCondition else {
            Utils.showAlert(title: "SwopIt", msg: "Please select Item Condition", vc: self)
            return
        }

        self.addItem(itemName: self.itemTitle.text!, itemDetails: self.itemDescription.text!, itemCondition: itmCondition, categoryId: (self.selectedSubCategory?.id!)!, userId: Utils.getLoggedInUserId(), images: images)
       
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if(collectionView == self.categoriesCollectionView){
            self.selectedCategory = self.cats?[indexPath.row]
            self.subcategoriesCollectionView.reloadData()
            self.categoriesCollectionView.reloadData()
        }
        else if(collectionView == self.subcategoriesCollectionView){
            self.selectedSubCategory = self.selectedCategory?.subCategories?[indexPath.row]
            self.subcategoriesCollectionView.reloadData()
            
        }
    }
    func updateItemImage(){
        self.presentImagePickingOptions()
    }
    
    func presentImagePickingOptions(){
        let alert = UIAlertController(title: "SwopIt", message: "Profile Image", preferredStyle: UIAlertControllerStyle.alert)
        let alertActionCamera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
            let picker: UIImagePickerController = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            picker.allowsEditing = true
            self.present(picker, animated: false) {
                
            }
            
        })
        alert.addAction(alertActionCamera)
        
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
            let picker: UIImagePickerController = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .savedPhotosAlbum
            picker.allowsEditing = true
            self.present(picker, animated: false) {
                
            }
        })
        alert.addAction(galleryAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                picker.dismiss(animated: false, completion: {
                    
                })
                self.setImage(image: pickedImage)
        }
    }
    
    func setImage(image: UIImage){
        switch self.currentUpdatingImageNumber {
        case 0:
            self.itemFirstImageV.image = image
            self.removeImg1.isHidden = false
            break
        case 1:
            self.itemSecondImageV.image = image
            self.removeImg2.isHidden = false
            break
        case 2:
            self.itemThirdImageV.image = image
            self.removeImg3.isHidden = false
            break
        case 3:
            self.fourthImageV.image = image
            self.removeImg4.isHidden = false
            break
        case 4:
            self.itemFifthImageV.image = image
            self.removeImg5.isHidden = false
            break
        default:
            break
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        return  CGSize(width: UIScreen.main.bounds.width/3 , height: 50)
    }
    @IBAction func uploadImage1(_ sender: Any) {
        self.currentUpdatingImageNumber = 0
        self.updateItemImage()
    }
    
    @IBAction func uploadImage2(_ sender: Any) {
        self.currentUpdatingImageNumber = 1
        self.updateItemImage()
    }
    @IBAction func uploadImage3(_ sender: Any) {
        self.currentUpdatingImageNumber = 2
        self.updateItemImage()
    }
    @IBAction func uploadImage4(_ sender: Any) {
        self.currentUpdatingImageNumber = 3
        self.updateItemImage()
    }
    
    @IBAction func uploadImage5(_ sender: Any) {
        self.currentUpdatingImageNumber = 4
        self.updateItemImage()
    }
    func addPlaceholderPadding(){
        let paddingView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10, height: 30))
        paddingView.backgroundColor = UIColor.clear
        let paddingView2 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10, height: 30))
        self.itemTitle.leftView = paddingView
        self.itemTitle.leftViewMode = .always
        self.itemDescription.leftView = paddingView2
        self.itemDescription.leftViewMode = .always
    }
    
    
    @IBAction func removeImage1Action(_ sender: Any) {
        self.itemFirstImageV.image = nil
        self.removeImg1.isHidden = true
    }

    @IBAction func removeImage2Action(_ sender: Any) {
        self.itemSecondImageV.image = nil
        self.removeImg2.isHidden = true
    }
   
    @IBAction func removeImage3Action(_ sender: Any) {
        self.itemThirdImageV.image = nil
        self.removeImg3.isHidden = true
    }

    @IBAction func removeImage4Action(_ sender: Any) {
        self.fourthImageV.image = nil
        self.removeImg4.isHidden = true
    }
    @IBAction func removeImage5Action(_ sender: Any) {
        self.itemFifthImageV.image = nil
        self.removeImg5.isHidden = true
    }
    @IBAction func itemTitleDidBeginEditing(_ sender: Any) {
        self.scrollInnerViewTopConstraint.constant = -250
          self.scrollInnerViewBottomConstraint.constant = 250
    }
    @IBAction func itemTitleDidEndEditing(_ sender: Any) {
        self.scrollInnerViewTopConstraint.constant = 0
        self.scrollInnerViewBottomConstraint.constant = 0
    }
    @IBAction func itemDescDidBeginEditing(_ sender: Any) {
        self.scrollInnerViewTopConstraint.constant = -250
        self.scrollInnerViewBottomConstraint.constant = 250
    }
    @IBAction func itemDescDidEndEditing(_ sender: Any) {
        self.scrollInnerViewTopConstraint.constant = 0
        self.scrollInnerViewBottomConstraint.constant = 0
    }
    
    
    @IBAction func moreThan2Years(_ sender: UIButton) {
        clearButtons()
        moreThan2YearsBtn.layer.borderColor = UIColor(hexString: "1B7F37").cgColor
        moreThan2YearsBtn.backgroundColor = UIColor(hexString: "1B7F37")
        itemCondition = "> 2 years"
    }
    
    @IBAction func lessThan2Years(_ sender: UIButton) {
        clearButtons()
        lessThan2YearsBtn.layer.borderColor = UIColor(hexString: "1B7F37").cgColor
        lessThan2YearsBtn.backgroundColor = UIColor(hexString: "1B7F37")
        itemCondition = "< 2 years"
    }
    
    @IBAction func newTapped(_ sender: UIButton) {
        clearButtons()
        newBtn.layer.borderColor = UIColor(hexString: "1B7F37").cgColor
        newBtn.backgroundColor = UIColor(hexString: "1B7F37")
        itemCondition = "New"
    }
    
    func clearButtons() {
        moreThan2YearsBtn.layer.borderColor = UIColor.lightGray.cgColor
        lessThan2YearsBtn.layer.borderColor = UIColor.lightGray.cgColor
        newBtn.layer.borderColor = UIColor.lightGray.cgColor
        moreThan2YearsBtn.backgroundColor = UIColor.white
        lessThan2YearsBtn.backgroundColor = UIColor.white
        newBtn.backgroundColor = UIColor.white
    }
    
}
