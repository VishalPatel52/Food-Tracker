//
//  DataController.swift
//  Food Tracker
//
//  Created by Vishal Patel on 23/01/15.
//  Copyright (c) 2015 Vishal Patel. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataController {
    
    class func jsonAsUSDAIdAndNameSearchResults (json : NSDictionary) -> [(name: String, idValue: String)]{
        var usdaItemSearchResults : [(name: String, idValue: String)] = []
        var searchResults: (name: String, idValue: String)
        
        if json["hits"] != nil{
            
            let resutls:[AnyObject] = json["hits"] as [AnyObject]
            
            for itemDictionary in resutls {
                if itemDictionary["_id"] != nil{
                    let fieldsDictioary = itemDictionary["fields"] as NSDictionary
                    if fieldsDictioary["item_name"] != nil{
                        let idValue:String = itemDictionary["_id"]! as String
                        let name:String = fieldsDictioary["item_name"]! as String
                        searchResults = (name:name, idValue:idValue)
                        usdaItemSearchResults += [searchResults]
                    }
                }
            }
        }
        return usdaItemSearchResults
    }
    
    
}