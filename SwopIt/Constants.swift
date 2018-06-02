//
//  Constants.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 2/12/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit

class Constants: NSObject {
    static let BASE_URL = "http://swopitapp1.azurewebsites.net/api/AlbertoMoll/"
    static let AUTHENTICATION_URL = BASE_URL + "Login"
    static let REGISTRATION_URL = BASE_URL + "AddUser"
    static let UPLOAD_PROFILE_PIC_URL = BASE_URL + "UploadProfilePicture"
    static let GET_PROFILE_PIC_URL = "http://swopitapp1.azurewebsites.net/Attachments/userprofilepics/"
    static let CHECK_USER_AVAILABILITY_URL = BASE_URL + "UserAvailablity"
    static let GET_ITEM_BY_USER_ID_URL = BASE_URL + "GetItemsByUser"
    static let ADD_ITEM_URL = BASE_URL +  "AddItem"
    static let UPDATE_USER_URL = BASE_URL + "UpdateUser"
    static let GET_ALL_CATEGORIES_URL = BASE_URL + "GetCategories"
    static let UPLOAD_ITEM_IMAGE = BASE_URL + "UploadItemImage"
    static let GET_ITEM_DETAIL_BY_ID = BASE_URL + "ItemById"
    static let DOWNLOAD_ITEM_IMAGE_URL = "http://swopitapp1.azurewebsites.net/Attachments/Items/"
    static let GET_USER_DETAILS_BY_ID = BASE_URL + "UserById"
    static let GET_ITEM_BY_DISTANCE = BASE_URL + "ItemsByDistance"
    static let GET_ITEM_BY_SEARCH = BASE_URL + "ItemsBySearch"
    static let SEND_SWOP_REQUEST = BASE_URL + "AddSwopRequest"
    static let GET_SWOP_REQUESTS = BASE_URL + "SwopRequestByUserId"
    static let GET_ITEMS_BY_CATEGORY_AND_USER_ID = BASE_URL + "GetItemsByUserAndCategory"
    static let UPDATE_REQUEST_STATUS = BASE_URL + "UpdateSwopRequestStatus"
    static let ADD_COINS_URL = BASE_URL + "AddCoins"
    static let EVALUATE_SWOPPER_URL = BASE_URL + "EvaluateSwopper"
    static let REDEEM_COINS_URL = BASE_URL + "RedeemCoins"
    static let UPDATE_COINS_URL = BASE_URL + "UpdateCoins"
    static let GET_ITEMS_BY_CATEGORY = BASE_URL + "ItemsByCategory"
    static let GET_CHAT_BY_TWO_USERS = BASE_URL + "ChatByTwoUsers"
    static let SEND_CHAT_MSG = BASE_URL + "AddChatMessage"
    static let GET_CHAT_LIST_BY_USER_ID = BASE_URL + "ChatByUserId"
    static let GET_SWOPPERS_BY_DISTANCE = BASE_URL + "Swoppers"
    static let GET_SWOP_HISTORY = BASE_URL + "AcceptedSwopsByUser"
    
    
    static let KEY_RESPONSE = "Response"
    static let KEY_RESPONSE_CODE = "ResponseCode"
    
    static let HTTP_METHOD_POST = "POST"
    static let HTTP_METHOD_GET = "GET"
    
    static let KEY_ID = "Id"
    
    static let KEY_USER_ID = "UserId"
    static let KEY_PASSWORD = "Password"
    static let KEY_NAME = "Name"
    static let KEY_USERNAME = "Username"
    static let KEY_EMAIL = "Email"
    static let KEY_PHONE = "Phone"
    static let KEY_ABOUT = "About"
    static let KEY_MORE_INFO = "MoreInfo"
    static let KEY_ADDRESS = "Address"
    static let KEY_LATITUDE = "Latitude"
    static let KEY_LONGITUDE = "Longitude"
    static let KEY_PROFILE_PICTURE = "ProfilePicture"
    static let KEY_URLS = "Urls"
    
    static let KEY_CATEGORY = "Category"
    static let KEY_CONDITION = "Condition"
    static let KEY_DETAILS = "Details"
    static let KEY_POST_DATE = "PostDate"
    
    static let KEY_ITEM_NAME = "ItemName"
    static let KEY_ITEM_DETAILS = "ItemDetails"
    static let KEY_ITEM_CONDITION = "ItemCondition"
    static let KEY_CATEGORY_ID = "CategoryId"
    static let KEY_ITEM_ID = "ItemId"
    static let KEY_SEARCH_TEXT = "SearchTxt"
    
    static let KEY_SUBCATEGORY = "subCategory"
    static let KEY_DISTANCE = "Distance"
    static let KEY_SUBCATEGORY_ID = "SubCategoryId"
}
