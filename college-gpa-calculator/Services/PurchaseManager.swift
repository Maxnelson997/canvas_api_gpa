//
//  PurchaseManager.swift
//  college-gpa-calculator
//
//  Created by Max Nelson on 12/5/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//


typealias CompletionHandler = (_ success: Bool) -> ()

import UIKit
import StoreKit

class PurchaseManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let instance = PurchaseManager()
    
    let IAP_REMOVE_ADS = "MaxNelson.CollegeGPACalculator.dopeedition1"
    
    var productsRequest: SKProductsRequest!
    var products = [SKProduct]()
    var transactionComplete: CompletionHandler?
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                if transaction.payment.productIdentifier == IAP_REMOVE_ADS {
                    transactionComplete?(true)
                    UserDefaults.standard.set(true, forKey: IAP_REMOVE_ADS)
                    GPModel.sharedInstance.userIsFreemium = false
                }
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                GPModel.sharedInstance.userIsFreemium = true
                transactionComplete?(false)
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                
                if transaction.payment.productIdentifier == IAP_REMOVE_ADS {
                    transactionComplete?(true)
                    UserDefaults.standard.set(true, forKey: IAP_REMOVE_ADS)
                    GPModel.sharedInstance.userIsFreemium = false
                }
                
            case .purchasing:
                print("state is purchasing")
//                SKPaymentQueue.default().finishTransaction(transaction)
//                if transaction.payment.productIdentifier == IAP_REMOVE_ADS {
//                    transactionComplete?(true)
//                    UserDefaults.standard.set(true, forKey: IAP_REMOVE_ADS)
//                    GPModel.sharedInstance.userIsFreemium = false
//                }
            default:
                print("defcase: \n")
                print(transaction.transactionState.rawValue)
                transactionComplete?(false)
            }
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count > 0 {
            print(response.products.debugDescription)
            products = response.products
        }
    }

    func restorePurchases(completion: @escaping CompletionHandler) {
        if SKPaymentQueue.canMakePayments()  {
            transactionComplete = completion
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().restoreCompletedTransactions()
        } else {
            print("uh restore purchase failed")
            completion(false)
        }
    }
    
    func purchaseDopeEdition(completion: @escaping CompletionHandler) {
        if SKPaymentQueue.canMakePayments() && products.count > 0 {
            transactionComplete = completion
            let dopeEditionProduct = products[0]
            let payment = SKPayment(product: dopeEditionProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            print("uhh")
            completion(false)
        }
    }
    
    func fetchProducts() {
        let productIds = NSSet(object: IAP_REMOVE_ADS) as! Set<String>
        productsRequest = SKProductsRequest(productIdentifiers: productIds)
        productsRequest.delegate = self
        productsRequest.start()
    }

}
