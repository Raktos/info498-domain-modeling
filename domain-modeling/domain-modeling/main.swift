//
//  main.swift
//  domain-modeling
//
//  Created by iGuest on 10/13/15.
//  Copyright (c) 2015 Jason Ho. All rights reserved.
//

import Foundation

enum Currency {
        case usd, gbp, eur, can
}

struct Money {
    
    var amount : Double
    var currency : Currency
    
    init(amount : Double, currency : Currency) {
        self.amount = amount
        self.currency = currency
    }
    
    mutating func convert(currency : Currency) {
        self.currency = currency
    }
    
    mutating func add(var amt : Double, currency : Currency) -> Void {
        amt = convertToUSD(amt, currency : currency)
        self.amount += amt
    }
    
    mutating func subtract(var amt : Double, currency : Currency) -> Void{
        amt = convertToUSD(amt, currency : currency)
        self.amount -= amt
    }
    
    func getAmount() -> Double {
        switch self.currency {
        case .can: return self.amount * 1.25
        case .eur: return self.amount * 1.5
        case .gbp: return self.amount * 0.5
        default: return self.amount
        }
    }
    
    private func convertToUSD(var amt : Double, currency : Currency) -> Double {
        switch currency {
        case .can: return amt * 0.8
        case .eur: return amt * (2.0 / 3.0)
        case .gbp: return amt * 2.0
        default : return amt
        }
    }
}

var m = Money(amount : 0.0, currency : Currency.usd)
m.add(5.0, currency : Currency.gbp)
println(m.getAmount())
m.add(10, currency : Currency.can)
println(m.getAmount())
m.add(9, currency : Currency.eur)
println(m.getAmount())
m.convert(Currency.gbp)
println(m.getAmount())
m.convert(Currency.eur)
println(m.getAmount())
m.convert(Currency.can)
println(m.getAmount())
m.add(10.0, currency : Currency.gbp)
println(m.getAmount())

enum SalaryType {
    case yearly, hourly
}

class Job {
    var title : String
    var salary : Double
    var salaryType : SalaryType
    
    init(title : String, salary : Double, salaryType : SalaryType) {
        self.title = title
        self.salary = salary
        self.salaryType = salaryType
    }
    
    func calculateIncome(hours : Double = 0.0) -> Double{
        switch self.salaryType {
        case .yearly: return self.salary
        case .hourly: return self.salary * hours
        }
    }
    
    func raise(raisePercent : Double) -> Void {
        self.salary *= 1 + raisePercent / 100
    }
}

var j = Job(title : "programmer", salary : 80000.0, salaryType : SalaryType.yearly)
println(j.calculateIncome())
j.raise(10)
println(j.calculateIncome(hours : 150.0))
j = Job(title : "lab tech", salary : 20.0, salaryType : SalaryType.hourly)
println(j.calculateIncome(hours : 100.0))
println(j.calculateIncome())

class Person {
    let firstName : String
    let lastName : String
    let age : Int
    var job : Job?
    var spouse : Person?
    
    init(firstName : String, lastName : String, age : Int, job : Job? = nil, spouse : Person? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        
        if age < 16 {
            self.job = nil
        } else {
            self.job = job
        }
        if age < 18 {
            self.spouse = nil
        } else {
            self.spouse = spouse
        }
    }
    
    func toString() -> String {
        let title = self.job != nil ? self.job!.title : "unemployed"
        let spouseName = self.spouse != nil ? "\(self.spouse!.firstName) \(self.spouse!.lastName)" : "unmarried"
        return "\(self.firstName) \(self.lastName)\nAge: (self.age) years\nJob: \(title)\nSpouse: \(spouseName)"
    }
}