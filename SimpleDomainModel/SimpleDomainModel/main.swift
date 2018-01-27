//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
    if self.currency == to {
        return self
    } else if self.currency == "USD" {
        if to == "GBP" {
            return Money(amount: self.amount / 2, currency: "GBP")
        } else if to == "EUR" {
            return Money(amount: Int(Double(self.amount) * 1.5), currency: "EUR")
        } else if to == "CAN" {
            return Money(amount: Int(Double(self.amount) * 1.25), currency: "CAN")
        }
    } else if self.currency == "GBP" {
        if to == "USD" {
            return Money(amount: self.amount * 2, currency: "USD")
        } else if to == "EUR" {
            return Money(amount: self.amount * 3, currency: "EUR")
        } else if to == "CAN" {
            return Money(amount: Int(Double(self.amount) * 2.5), currency: "CAN")
        }
    } else if self.currency == "EUR" {
        if to == "USD" {
            return Money(amount: Int(Double(self.amount) / 1.5), currency: "USD")
        } else if to == "GBP" {
            return Money(amount: self.amount / 3, currency: "GBP")
        } else if to == "CAN" {
            return Money(amount: Int(Double(self.amount) / 1.2), currency: "CAN")
        }
    } else if self.currency == "CAN" {
        if to == "USD" {
            return Money(amount: Int(Double(self.amount) / 1.25), currency: "USD")
        } else if to == "GBP" {
            return Money(amount: Int(Double(self.amount) / 2.5), currency: "GBP")
        } else if to == "EUR" {
            return Money(amount: Int(Double(self.amount) * 1.2), currency: "EUR")
        }
    }
    print("Err: invalid currency")
    return self
  }
  
  public func add(_ to: Money) -> Money {
    return Money(amount: self.convert(to.currency).amount + to.amount, currency: to.currency)
  }
  public func subtract(_ from: Money) -> Money {
    return Money(amount: self.convert(from.currency).amount - from.amount, currency: from.currency)
  }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch type {
    case .Hourly(let rate):
        return Int(rate * Double(hours))
    case .Salary(let salary):
        return salary
    }
  }
  
  open func raise(_ amt : Double) {
    switch type {
    case .Hourly(let rate):
        self.type = Job.JobType.Hourly(rate + amt)
    case .Salary(let salary):
        self.type = Job.JobType.Salary(salary + Int(amt))
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {
        return self._job
    }
    set(value) {
        if self.age >= 18 {
            self._job = value
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {
        return self._spouse
    }
    set(value) {
        if self.age >= 21 {
            self._spouse = value
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(String(describing: self.job?.type)) spouse:\(String(describing: self.spouse?.firstName))]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if spouse1.spouse == nil && spouse2.spouse == nil {
        members.append(spouse1)
        members.append(spouse2)
    } else {
        print("error: spouse already married")
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    if members[0].age >= 21 || members[1].age >= 21 {
        members.append(child)
        return true
    } else {
        print("error: one or both parents must be 21")
        return false
    }
  }
  
  open func householdIncome() -> Int {
    var income = 0
    for member in members {
        if ((member.job) != nil) {
            income += (member.job?.calculateIncome(2000))!
        }
    }
    return income
  }
}





