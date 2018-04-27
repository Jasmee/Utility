//
//  ReadLocalJSONViewController.swift
//  Utility
//
//  Created by Jasmee Sengupta on 06/03/18.
//  Copyright © 2018 Jasmee Sengupta. All rights reserved.
//  Reading local JSON into a dictionary

import Foundation
import UIKit

class ReadLocalJSONViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        readJSONFrom(file: "Config")
        //readJSONStringFrom(fileName: "Config")
    }
    
    func readJSONFrom(file: String) {
        guard let data = readFile(name: file) else { return }
        var jsonDict: NSDictionary?
        let jsonData = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
        jsonDict = jsonData as! NSDictionary?
        print(jsonDict)
        if let data1 = jsonDict?["data"] as? [String: Any] {//nil why?
            if let info = data1["catalogueInfo"] as? [String: Any] {
                if let gold_rate = info["gold_rate"] as? String {
                    print(gold_rate)
                }
            }
        }
        isValidJSON(object: jsonDict!)
    }
    
    func readFile(name fileName: String) -> Data? {// make it throw
        guard let fileURL = getFileURLDirect(name: fileName) else { return nil }
        var jsonData: Data?
        do {
            jsonData = try Data(contentsOf: fileURL)
            print(jsonData)
        } catch let error {
            print("Error thrown while reading file \(error)")
        }
        return jsonData
    }
    
    func getFileURL(name: String) -> URL? {
        guard let filePath = getFilePath(name: name) else { return nil }
        let prefix = "file://"
        let completeFilePath = prefix + filePath
        // why prefix? throws error otherwise in data(contentsofurl method)
        //CFURLCopyResourcePropertyForKey failed because it was passed an URL which has no scheme
        //Error thrown Error Domain=NSCocoaErrorDomain Code=256 "The file “Config.json” couldn’t be opened."
        guard let fileURL = URL(string: completeFilePath) else {
            print("Could not construct URL from file path")
            return nil
        }
        return fileURL
    }
    
    func getFilePath(name: String) -> String? {
        guard let filePath = Bundle.main.path(forResource: name, ofType: "json") else {
            print("Could not get file path.")
            return nil
            
        }
        return filePath
    }
    
    /**
     This function returns the file url for the specified file
     @param: name - description --??? parameter description
 */
    func getFileURLDirect(name: String) -> URL? {// if we use this, no need to prefix "file://"
        guard let fileURL = Bundle.main.url(forResource: name, withExtension: "json") else {
            print("Could not get file path.")
            return nil
            
        }
        return fileURL
    }
    
    func isValidJSON(object: Any) {// call on a jsonDict object
        if JSONSerialization.isValidJSONObject(object) {
            print("valid JSON")
        } else {
            print("JSON is not valid")
        }
    }
    
    // fileutility
    func readJSONStringFrom(fileName: String) {
        guard let fileURL = getFileURLDirect(name: fileName) else { return }
        if let rawData = try? Data(contentsOf: fileURL) {
            if let dataString = String(data: rawData, encoding: .utf8) {
                print(dataString) // if printed as optional, we get intermittent \n characters
            } else {
                print("Could not convert to string")
            }
        } else {
            print("Could not read file")
        }
    }
    
    // All in one place for complete overview
    func readJSONFromFile(name: String) {
        
    }

}
