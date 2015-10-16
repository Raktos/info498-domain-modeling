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
    
    private var amount : Double
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
    
    mutating func subtract(var amt : Double, currency : Currency) -> Void {
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

print("Money Tests:")
var m = Money(amount : 0.0, currency : Currency.usd)
print("Created a Money in USD with 0.0\n")
m.add(5.0, currency : Currency.gbp)
print("added 5GBP. currently contains \(m.getAmount()) in USD\n")
m.add(10, currency : Currency.can)
print("added 10CAN. currently contains \(m.getAmount()) in USD\n")
m.add(9, currency : Currency.eur)
print("added 9EUR. currently contains\(m.getAmount()) in USD\n")
m.convert(Currency.gbp)
print("convert to GBP. currently contains \(m.getAmount()) in GBP \n")
m.convert(Currency.eur)
print("convert to EUR. currently contains \(m.getAmount()) in EUR\n")
m.convert(Currency.can)
print("conver to CAN. currently contains \(m.getAmount()) in CAN\n")
m.add(10.0, currency : Currency.gbp)
print("added 10GBP. currently contains \(m.getAmount()) in CAN \n")
print("\n")

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

print("Job Tests:\n")
var j = Job(title : "programmer", salary : 80000.0, salaryType : SalaryType.yearly)
print("Job with income of \(j.calculateIncome()) yearly\n")
j.raise(10)
print("raise of 10%. income is now \(j.calculateIncome())\n")
j = Job(title : "lab tech", salary : 20.0, salaryType : SalaryType.hourly)
print("Job with income of 20 hourly makes \(j.calculateIncome(hours: 100.0)) in 100 hours\n")
print("\n")

class Person {
    let firstName : String
    let lastName : String
    var age : Int
    var job : Job?
    weak var spouse : Person?
    
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
        return "\(self.firstName) \(self.lastName)\nAge: \(self.age) years\nJob: \(title)\nSpouse: \(spouseName)\n"
    }
}

print("Person Tests:\n")
var p1 = Person(firstName : "John", lastName : "Dole", age : 47, job : j)
print("\(p1.toString())\n")
var p2 = Person(firstName : "Joanne", lastName : "Dole", age : 45, spouse : p1)
print("\(p2.toString())\n")
p1.spouse = p2
print("\(p1.toString())\n")
var p3 = Person(firstName : "Bobby", lastName : "Dole", age : 15, job : j, spouse : p1)
print("\(p3.toString())\n")

class Family {
    var members : [Person] = []
    
    init?(members : [Person]) {
        var legalFamily : Bool = false
        for p in members {
            if p.age > 20 {
                legalFamily = true
            }
        }

        if !legalFamily {
            return nil
        }
        self.members = members
    }
    
    func householdIncome() -> Double{
        var totalIncome = 0.0
        for p in self.members {
            if p.job != nil {
                totalIncome += p.job!.calculateIncome(hours : 8760.0) //a year's worth of hours
            }
        }
        return totalIncome
    }
    
    func haveChild() -> Void {
        self.members.append(Person(firstName : "new", lastName : "baby", age : 0))
    }
}

var f = Family(members : [p1,p2,p3])
print("Family Tests:\n")
print("Creatin famiy of John, Joanne, and Bobby\n")
if f == nil {
    print(f)
}else {
    for p in f!.members {
        print("\(p.toString())\n")
    }
}

f = Family(members: [p3])
print("creaing family of just Bob\n")
if f == nil {
    print("family is nil")
}else {
    for p in f!.members {
        print("\(p.toString())\n")
    }
}