//
//  ItemsListTableViewCell.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 3/7/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import SDWebImage

protocol ItemProtocol{
    func goToItemDetails(item: Item, indexPath: IndexPath)
    func goToUserProfile(userId : String)
}

class ItemsListTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var itemImagesCollectionViewCell: UICollectionView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var itemDescriptionLbl: UILabel!
    @IBOutlet weak var profileImgV: UIImageView!
    @IBOutlet weak var itemImgV: UIImageView!
    @IBOutlet weak var postedLbl: UILabel!
    var item: Item?
    var indexPath: IndexPath?
    var delegate: ItemProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(item: Item, indexPath: IndexPath, delegate: ItemProtocol){
        self.item = item
        self.indexPath = indexPath
        self.delegate = delegate
        let collCellNib =  UINib(nibName: "ItemDetailImageCollectionViewCell", bundle: nil)
        self.itemImagesCollectionViewCell.register(collCellNib, forCellWithReuseIdentifier: "ItemDetailImageCollectionViewCell")
        self.itemImagesCollectionViewCell.delegate = self
        self.itemImagesCollectionViewCell.dataSource = self
        self.profileImgV.layer.cornerRadius = self.profileImgV.frame.width/2
        self.profileImgV.clipsToBounds = true
        if(item.urls.count > 0){
            let imgUrl = Constants.DOWNLOAD_ITEM_IMAGE_URL + item.urls[0]
            self.itemImgV.sd_setImage(with: URL(string: imgUrl))
        }
        self.itemDescriptionLbl.text = item.name!
        
        var usrNm = (item.user?.name!)!
        if(usrNm.characters.count > 10){
            let index = usrNm.index(usrNm.startIndex, offsetBy: 10)
            usrNm = usrNm.substring(to: index)
        }
        self.postedLbl.text = usrNm + " posted"
        var floatVal = Float(0.0)
        if(item.distance != nil){
          floatVal = Float(item.distance!)!
        }
        let intVal = Int(floatVal)
        self.distanceLbl.text = String(intVal) + " km"
        if(item.user?.profilePictureUrl != nil){
            let profilePic = Constants.GET_PROFILE_PIC_URL + (item.user?.profilePictureUrl)!
            let url = URL(string: profilePic)
            self.profileImgV.sd_setImage(with: url, placeholderImage: UIImage(named: "profile_placeholder"))
        }
        self.pageControl.numberOfPages = (self.item?.urls.count)!
        self.itemImagesCollectionViewCell.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if((self.item?.urls.count)! <= 0){
            self.itemImagesCollectionViewCell.isHidden = true
        }
        else{
            itemImagesCollectionViewCell.isHidden = false
        }
        return (self.item?.urls.count)!
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemDetailImageCollectionViewCell", for: indexPath) as! ItemDetailImageCollectionViewCell
        cell.updateCell(imageUrl: (item?.urls[indexPath.row])!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        return  CGSize(width: UIScreen.main.bounds.width , height: 221.5)
    }
    func horizontalPageNumber(scrollView:UIScrollView) ->Int{
        let contentOffset:CGPoint  = scrollView.contentOffset;
        let viewSize: CGSize  = scrollView.bounds.size;
        
        let horizontalPage:Int  = Int((contentOffset.x / viewSize.width))
        
        // Here's how vertical would work...
        //NSInteger verticalPage = MAX(0.0, contentOffset.y / viewSize.height);
        
        return horizontalPage;
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = self.horizontalPageNumber(scrollView: scrollView)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        self.delegate?.goToItemDetails(item: self.item!, indexPath: self.indexPath!)
    }
    @IBAction func tappedOnUserProfile(_ sender: Any) {
        self.delegate?.goToUserProfile(userId: (self.item?.user?.userId!)!)
    }

}
