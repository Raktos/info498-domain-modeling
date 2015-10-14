//
//  main.swift
//  domain-modeling
//
//  Created by iGuest on 10/13/15.
//  Copyright (c) 2015 Jason Ho. All rights reserved.
//

import Foundation

struct Money {
    enum Currency {
        case usd, gbp, eur, can
    }
    
    var amount : Double
    var currency : Currency
    
    init(initialAmt : Double, currency : Currency) {
        self.amount = initialAmt
        self.currency = currency
    }
    
    mutating func convert(currency : Currency) {
        self.currency = currency
    }
    
    func add(var amt : Double, currency : Currency) {
        
    }
    
    func subtract(var amt : Double, currency : Currency) {
        
    }
    
    private func convertToUSD(var amt : Double, currency : Currency) -> Double {
        switch currency {
        case .can: amt *= 0.8
        case .eur: amt *= (2.0 / 3.0)
        case .gbp: amt *= 2.0
        default : break
        }
        return amt
    }
}