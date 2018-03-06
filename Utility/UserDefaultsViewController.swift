//
//  UserDefaultsViewController.swift
//  Utility
//
//  Created by Jasmee Sengupta on 06/03/18.
//  Copyright © 2018 Jasmee Sengupta. All rights reserved.
//

import Foundation
import UIKit

class UserDefaultsViewcontroller: UIViewController {
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         storeAndRetrieveURL()
         storeAndRetrieveDate()
         storeAndRetrieveBool()
         storeAndRetrieveDictionary()
         storeAndRetrieveArray()
         storeAndRetrieveNumbers()
         storeAndRetrieveData()
         */
        //Pick your choice from above
        storeAndRetrieveNumbers()
    }
    
    func storeAndRetrieveNumbers() {// key not present returns 0 check, object value
        print("Int")
        defaults.set(25, forKey: "Age") // Int
        let age = defaults.integer(forKey: "Age")
        print(age)
        let age1 = defaults.integer(forKey: "Age1")
        print(age1)
        print("Age as array")
        if let ageArray = defaults.array(forKey: "Age") as? [Int] { // returns [Any]?
            print(ageArray) // returns nil, cannot put in array
        }
        getObjectAndValueFor(key: "Age", type: "Int") // 25 25
        
        print("Float")
        defaults.set(CGFloat.pi, forKey: "Pi") // Float
        let pi = defaults.float(forKey: "Pi")
        print(pi) // 3.14159
        let pi1 = defaults.float(forKey: "Pi1")
        print(pi1) // 0.0
        getObjectAndValueFor(key: "Pi", type: "Float") // 3.141592653589793 3.141592653589793
        
        print("Double")
        defaults.set(25.0, forKey: "Price") // Double
        let price = defaults.double(forKey: "Price")
        print(price) // 25.0
        let price1 = defaults.double(forKey: "Price1")
        print(price1) // 0.0
        print("getting integer from double")
        let price2 = defaults.integer(forKey: "Price") // integer = 25, float = 25.0 so converts if possible
        print(price2)
        getObjectAndValueFor(key: "Price", type: "Double") // 25, 25 why???
        
        print("String")
        defaults.set("Jas", forKey: "Name") // String, optional
        if let name = defaults.string(forKey: "Name") {
            print(name)
        }
        getObjectAndValueFor(key: "Name", type: "String") // Jas Jas
    }
    
    func storeAndRetrieveArray() {
        print("String Array")
        let fruits = ["Apple", "Banana"]
        defaults.set(fruits, forKey: "fruits") // Array
        if let fruitsArray = defaults.array(forKey: "fruits") as? [String] { // returns [Any]?
            print(fruitsArray)
        }
        getObjectAndValueFor(key: "fruits", type: "String Array")
        
        print("Numbers Array")
        let numbers = [1,2,3,4,5] // float double boolean
        defaults.set(numbers, forKey: "numbers") // Array
        if let numbersArray = defaults.array(forKey: "numbers") {
            print(numbersArray)
        }
        print("Numbers Array in string")
        if let numbersString = defaults.stringArray(forKey: "numbers") { // returns [String]?
            print(numbersString) // nil
            // The array of string objects, or nil if the specified default does not exist, the default does not contain an array, or the array does not contain strings.
        }
        getObjectAndValueFor(key: "numbers", type: "Number Array")
        // both prints:
        //        Number Array value
        //        (
        //            1,
        //            2,
        //            3,
        //            4,
        //            5
        //        )
    }
    
    func storeAndRetrieveDictionary() {
        print("Dictionary")
        let dict = ["India": "Taj Mahal", "Peru": "Machu Picchu"]
        defaults.set(dict, forKey: "dictionary") // Dictionary
        if let dictionary = defaults.dictionary(forKey: "dictionary") as? [String: String]{ // [String: Any]?
            print(dictionary) // ["Peru": "Machu Picchu", "India": "Taj Mahal"] - Swift dictionary
        }
        getObjectAndValueFor(key: "dictionary", type: "Dictionary")
        // both prints:
        //        Dictionary object
        //            {
        //                India = "Taj Mahal";
        //                Peru = "Machu Picchu";
        //        }
    }
    
    func storeAndRetrieveBool() {
        print("Bool")
        defaults.set(true, forKey: "isRaining") // Bool
        let isRaining = defaults.bool(forKey: "isRaining")
        print(isRaining)
        let isntRaining = defaults.bool(forKey: "isntRaining")
        print(isntRaining) // returns false if key not there, not optinal
        getObjectAndValueFor(key: "isRaining", type: "Bool")
        // both prints 1 for true
        getObjectAndValueFor(key: "isntRaining", type: "Bool")
        // method returns nil, hence no value
        defaults.set(false, forKey: "liar") // Bool
        let liar = defaults.bool(forKey: "liar")
        print(liar)
        getObjectAndValueFor(key: "liar", type: "Bool")
        // both prints 0 for false
    }
    
    func storeAndRetrieveDate() {
        print("Date")
        defaults.set(Date(), forKey: "CurrentDate") // Date
        if let today = defaults.object(forKey: "CurrentDate") as? Date {// no date method?
            print(today) // 2018-03-06 06:47:58 +0000
        }
        getObjectAndValueFor(key: "CurrentDate", type: "Date") // 2018-03-06 06:47:58 +0000 both
    }
    
    func storeAndRetrieveURL() {
        print("URL")
        defaults.set(URL(string: "www.google.com")!, forKey: "URL") // URL
        if let myURL = defaults.url(forKey: "URL") { // returns URL?
            print(myURL) // "www.google.com"
        }
        getObjectAndValueFor(key: "URL", type: "URL")
        // both above prints the object: <62706c69 73743030 d4010203 04050616 17582476 65727369 6f6e5824 6f626a65 63747359 24617263 68697665 72542474 6f701200 0186a0a4 07080f10 55246e75 6c6cd309 0a0b0c0d 0e574e53 2e626173 65562463 6c617373 5b4e532e 72656c61 74697665 80008003 80025e77 77772e67 6f6f676c 652e636f 6dd21112 13145a24 636c6173 736e616d 65582463 6c617373 6573554e 5355524c a2131558 4e534f62 6a656374 5f100f4e 534b6579 65644172 63686976 6572d118 1954726f 6f748001 08111a23 2d32373c 42495158 6466686a 797e8992 989ba4b6 b9be0000 00000000 01010000 00000000 001a0000 00000000 00000000 00000000 00c0>
        // not boolean value : 1 or 0
    }
    
    func storeAndRetrieveData() {
        print("Data")
        let string = "I am good"
        guard let encodedString = string.data(using: .utf8) else { return }
        let data = Data(encodedString)
        defaults.set(data, forKey: "data") // Data
        if let myData = defaults.data(forKey: "data") { // returns Data?
            print(myData, myData.count) // 9 bytes, 9
        }
    }
    
    func getObjectAndValueFor(key: String, type: String) {
        print("\(type) object")
        if let object = defaults.object(forKey: key) {
            print(object)
        }
        print("\(type) value")
        if let value = defaults.value(forKey: key) {
            print(value)
        }
    }
    
}
