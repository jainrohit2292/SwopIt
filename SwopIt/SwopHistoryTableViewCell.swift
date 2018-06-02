//
//  SwopHistoryTableViewCell.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 6/4/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit

class SwopHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var swopStatus: UILabel!
    @IBOutlet weak var itemImageV: UIImageView!
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var streetAddress: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImgV: UIImageView!
    
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var itemNameLbl: UILabel!
    var swopRequest: SwopRequest?
    
    @IBOutlet weak var swoppedStatusView: UIView!
    var delegate: SwopRequestProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateCell(swopRequest : SwopRequest, delegate: SwopRequestProtocol){
        self.delegate = delegate
        self.swopRequest = swopRequest
        var url = ""
        self.profileImgV.layer.cornerRadius = self.profileImgV.frame.width/2
        self.profileImgV.clipsToBounds = true
        self.swoppedStatusView.isHidden = false
//        if(swopRequest.status! == "Accept"){
//            self.swopStatus.text = "Accepted"
//        }
//        else if(swopRequest.status! == "Reject"){
//            self.swopStatus.text = "Rejected"
//        }
//        else{
//            self.swoppedStatusView.isHidden = true
//        }
        if(swopRequest.swopType != nil && (swopRequest.swopType?.characters.count)! > 0){
            self.distanceLbl.text = "Type: " + swopRequest.swopType!
        }
        let dt = self.getDate(dateStr: swopRequest.date!)
        self.dateLbl.text = self.getFormattedDateStr(date: dt)
        if((swopRequest.senderItems?.count)! > 0){
            if((swopRequest.senderItems?[0].urls.count)! > 0){
                url = (swopRequest.senderItems?[0].urls[0])!
            }
            self.itemImageV.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named:"placeholder"))
            self.profileImgV.sd_setImage(with: URL(string: Constants.GET_PROFILE_PIC_URL + swopRequest.sender!.profilePictureUrl!), placeholderImage: UIImage(named:"profile_placeholder"))
            self.nameLbl.text = swopRequest.sender?.name!
            self.itemNameLbl.text = swopRequest.senderItems?[0].name!
            self.distanceLbl.text = swopRequest.senderItems?[0].distance
        }
        else if((swopRequest.receiverItems?.count)! > 0){
            if((swopRequest.receiverItems?[0].urls.count)! > 0){
                url = (swopRequest.receiverItems?[0].urls[0])!
            }
            print("Url : \(url)")
            self.itemImageV.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named:"placeholder.png"))
            self.profileImgV.sd_setImage(with: URL(string: Constants.GET_PROFILE_PIC_URL + swopRequest.sender!.profilePictureUrl!), placeholderImage: UIImage(named:"profile_placeholder"))
            self.nameLbl.text = swopRequest.sender?.name!
            self.itemNameLbl.text = swopRequest.receiverItems?[0].name!
            //            self.distanceLbl.text = swopRequest.receiverItems?[0].distance!
        }
        
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

    @IBAction func goToUserProfile(_ sender: Any) {
        self.delegate?.goToProfile(userId: self.swopRequest!.receiver!.userId!)
    }
}
