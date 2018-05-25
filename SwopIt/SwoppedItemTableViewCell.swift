//
//  SwoppedItemTableViewCell.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 5/2/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit

class SwoppedItemTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLblWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var profileImgV: UIImageView!
    
    @IBOutlet weak var dateTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var itemImageV: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func updateCell(item : Item){
        
        var url = ""
        self.profileImgV.layer.cornerRadius = self.profileImgV.frame.width/2
        self.profileImgV.clipsToBounds = true
        let dt = self.getDate(dateStr: item.postDate!)
        self.dateLbl.text = self.getFormattedDateStr(date: dt)

            if((item.urls.count) > 0){
                url = (item.urls[0])
            }
            self.itemImageV.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named:"placeholder"))
            self.profileImgV.sd_setImage(with: URL(string:(item.user?.profilePictureUrl!)!), placeholderImage: UIImage(named:"profile_placeholder"))
            self.nameLbl.text = item.user?.name!
            self.itemLbl.text = item.name!
//            self.distanceLbl.text = item.distance!

    }
    func updateCell(item : Item, selected: Bool){
//        if(selected){
//            self.backgroundColor = UIColor.gray
//        }
//        else{
//            self.backgroundColor = UIColor.white
//        }
        var url = ""
        self.profileImgV.layer.cornerRadius = self.profileImgV.frame.width/2
        self.profileImgV.clipsToBounds = true
        let dt = self.getDate(dateStr: item.postDate!)
        self.dateLbl.text = self.getFormattedDateStr(date: dt)
        
        if((item.urls.count) > 0){
            url = (item.urls[0])
        }
        self.itemImageV.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named:"placeholder"))
        self.profileImgV.sd_setImage(with: URL(string:(item.user?.profilePictureUrl!)!), placeholderImage: UIImage(named:"profile_placeholder"))
        self.nameLbl.text = item.user?.name!
        self.itemLbl.text = item.name!
        if(selected){
//            self.dateTrailingConstraint.constant = 30
            self.nameLblWidthConstraint.constant = 50
        }
        else{
//            self.dateTrailingConstraint.constant = 13
            self.nameLblWidthConstraint.constant = 70
        }
        //            self.distanceLbl.text = item.distance!
        
    }
    func getDate(dateStr: String) -> Date{
        let dfm = DateFormatter()
        dfm.dateFormat = "MM/dd/yyyy HH:mm:ss"
        return dfm.date(from: dateStr)!
    }
    func getFormattedDateStr(date: Date) -> String{
        let dfm = DateFormatter()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        print("Day : \(date)")
        dfm.dateFormat = "MMMM \(day), YYYY"
        return dfm.string(from: date)
    }
    
}
