//
//  IAPHelper.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 5/16/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit
import StoreKit

protocol IAHelperProtocol {
    func onProductsAvailable()
    func onProductsNotAvailable()
    func onTransactionFailed()
    func onTransactionPassed()
}

class IAPHelper: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var productIDs: [String?] = []
    var selectedProductIndex: Int?
    var productsArray: [SKProduct?] = []
    static var transactionInProgress = false
    var delegate: IAHelperProtocol?
    init(delegate: IAHelperProtocol){
        super.init()
        productIDs.append("com.swopit.SwopIt")
        productIDs.append("com.swopit.SwopIt1")
        productIDs.append("com.swopit.SwopIt2")
        self.delegate = delegate
        SKPaymentQueue.default().add(self)
    }
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = NSSet(array: productIDs)
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            print("Cannot perform In App Purchases.")
        }
    }
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse){
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product)
            }
            print("Products Array Count : \(productsArray.count)")
            self.delegate?.onProductsAvailable()
//            tblProducts.reloadData()
        }
        else {
            print("There are no products.")
            self.delegate?.onProductsNotAvailable()
        }
    
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]){
        for transaction in transactions as! [SKPaymentTransaction] {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                print("Transaction completed successfully.")
                SKPaymentQueue.default().finishTransaction(transaction)
//                transactionInProgress = false
                if(self.selectedProductIndex == nil){
                    self.selectedProductIndex = 0
                }
                self.addCoins(productIndex: self.selectedProductIndex!)
                    
                break
                
            case SKPaymentTransactionState.failed:
                print("Transaction Failed");
                SKPaymentQueue.default().finishTransaction(transaction)
//                transactionInProgress = false
                self.delegate?.onTransactionFailed()
            default:
//                print(transaction.transactionState.rawValue)
                break
            }
        }
    }
    func buy(index: Int){
        self.selectedProductIndex = index
        let payment = SKPayment(product: self.productsArray[index]! as SKProduct)
        SKPaymentQueue.default().add(payment)
        
    }
    func addCoins(productIndex: Int){
        switch productIndex {
        case 0:
            self.addCoinsRequest(numOfCoins: 5)
            break
        case 1:
            self.addCoinsRequest(numOfCoins: 50)
            break
        case 2:
            self.addCoinsRequest(numOfCoins: 200)
            break
        default:
            break
        }
    }
    func addCoinsRequest(numOfCoins: Int){
        var currCoins = Utils.getCurrNumOfCoins()
        if(currCoins == nil){
            currCoins = 0
        }
        let totalCoins = currCoins! + numOfCoins
        let params = ["UserId":Utils.getLoggedInUserId(), "Coins": String(totalCoins)]
        Utils.httpCall(url: Constants.UPDATE_COINS_URL, params: params as [String : AnyObject]?, httpMethod: "POST") { (response) in
            print("Response : \(response)")
            if((response?[Constants.KEY_RESPONSE_CODE] as! Int) == 1){
//                self.delegate?.onTransactionPassed()
            }
        }
    }
}
