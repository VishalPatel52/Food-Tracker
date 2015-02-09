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

let kUSDAItemCompleted = "USDAItemInstanceComplete"

class DataController {
    
    class func jsonAsUSDAIdAndNameSearchResults (json : NSDictionary) -> [(name: String, idValue: String)]{
        var usdaItemSearchResults : [(name: String, idValue: String)] = []
        var searchResults: (name: String, idValue: String)
        
        if json["hits"] != nil{
            
            let resutls:[AnyObject] = json["hits"]! as [AnyObject]
            
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
    
    func saveUSDAItemForId (idValue : String, json : NSDictionary) {
        if json["hits"] != nil{
            let results:[AnyObject] = json["hits"]! as [AnyObject]
            for itemDictionary in results {
                
                if itemDictionary["_id"] != nil && itemDictionary["_id"]! as String == idValue{
                    let manageObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
                    
                    var requestUSDAItem = NSFetchRequest(entityName: "USDAItem")
                    let itemDictionaryId = itemDictionary["_id"]! as String
                    
                    let predicate = NSPredicate(format: "idValue == %@", itemDictionaryId)
                    requestUSDAItem.predicate = predicate
                    
                    var error : NSError?
                    var items = manageObjectContext?.executeFetchRequest(requestUSDAItem, error: &error)
                    
                    //other way to get count of already saved entity in CoreData
                    //                    var count = manageObjectContext?.countForFetchRequest(requestUSDAItem, error: &error)
                    
                    if items?.count != 0 {
                        // this item is already saved
                        println("This item is already saved!")
                        return
                    }
                    else {
                        println("Let's save this item to CoreData")
                        
                        let entityDiscription = NSEntityDescription.entityForName("USDAItem", inManagedObjectContext: manageObjectContext!)
                        let usdaItem = USDAItem(entity: entityDiscription!, insertIntoManagedObjectContext:manageObjectContext!)
                        usdaItem.idValue = itemDictionary["_id"]! as String
                        usdaItem.dateAdded = NSDate()
                        
                        if itemDictionary["fields"] != nil{
                            let fieldsDictionary = itemDictionary["fields"]! as NSDictionary
                            if fieldsDictionary["item_name"] != nil {
                                usdaItem.name = fieldsDictionary["item_name"]! as String
                            }
                            
                            if fieldsDictionary["usda_fields"] != nil {
                                let usdaFieldsDictionary = fieldsDictionary["usda_fields"]! as NSDictionary
                                
                                if usdaFieldsDictionary["CA"] != nil {
                                    let calciumDictionary = usdaFieldsDictionary["CA"]! as NSDictionary
                                    if calciumDictionary["value"] != nil{
                                        let calciumValue: AnyObject = calciumDictionary["value"]!
                                        usdaItem.calcium = "\(calciumValue)"
                                    }
                                    
                                }
                                else {
                                    usdaItem.calcium = "0"
                                }
                                
                                
                                if usdaFieldsDictionary["CHOCDF"] != nil {
                                    let carbohydrateDictionary = usdaFieldsDictionary["CHOCDF"]! as NSDictionary
                                    if carbohydrateDictionary["value"] != nil{
                                        let carbohydrateValue:AnyObject = carbohydrateDictionary["value"]!
                                        usdaItem.carbohydrate = "\(carbohydrateValue)"
                                    }
                                    
                                }
                                else {
                                    usdaItem.carbohydrate = "0"
                                }
                                
                                
                                if usdaFieldsDictionary["FAT"] != nil {
                                    let fatTotalDictionary = usdaFieldsDictionary["FAT"]! as NSDictionary
                                    if fatTotalDictionary["value"] != nil{
                                        let fatTotalValue:AnyObject = fatTotalDictionary["value"]!
                                        usdaItem.fatTotal = "\(fatTotalValue)"
                                    }
                                }
                                else {
                                    usdaItem.fatTotal = "0"
                                }
                                
                                if usdaFieldsDictionary["CHOLE"] != nil{
                                    let cholesterolDictionary = usdaFieldsDictionary["CHOLE"]! as NSDictionary
                                    if cholesterolDictionary["value"] != nil {
                                        let cholesterolValue: AnyObject = cholesterolDictionary["value"]!
                                        usdaItem.cholesterol = "\(cholesterolValue)"
                                    }
                                }
                                else {
                                    usdaItem.cholesterol = "0"
                                }
                                
                                
                                if usdaFieldsDictionary["PROCNT"] != nil {
                                    let proteinDictionary = usdaFieldsDictionary["PROCNT"]! as NSDictionary
                                    if proteinDictionary["value"] != nil{
                                        let proteinValue:AnyObject = proteinDictionary["value"]!
                                        usdaItem.protein = "\(proteinValue)"
                                    }
                                }
                                else{
                                    usdaItem.protein = "0"
                                }
                                
                                
                                if usdaFieldsDictionary["SUGAR"] != nil{
                                    let sugarDictionary = usdaFieldsDictionary["SUGAR"]! as NSDictionary
                                    if sugarDictionary["value"] != nil{
                                        let sugarValue:AnyObject = sugarDictionary["value"]!
                                        usdaItem.sugar = "\(sugarValue)"
                                    }
                                }
                                else{
                                    usdaItem.sugar = "0"
                                }
                                
                                if usdaFieldsDictionary["VITC"] != nil{
                                    let vitaminCDictionary = usdaFieldsDictionary["VITC"]! as NSDictionary
                                    if vitaminCDictionary["value"] != nil{
                                        let vitaminCValue:AnyObject = vitaminCDictionary["value"]!
                                        usdaItem.vitaminC = "\(vitaminCValue)"
                                    }
                                }
                                else{
                                    usdaItem.vitaminC = "0"
                                }
                                
                                if usdaFieldsDictionary["ENERC_KCAL"] != nil{
                                    let energyDictionary = usdaFieldsDictionary["ENERC_KCAL"]! as NSDictionary
                                    if energyDictionary["value"] != nil{
                                        let energyValue:AnyObject = energyDictionary["value"]!
                                        usdaItem.energy = "\(energyValue)"
                                    }
                                }
                                else{
                                    usdaItem.energy = "0"
                                }
                                
                                
                                // now save these items and values in CoreData
                                
                                (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
                                
                                // MARK: - NSNotificationCenter
                                
                                NSNotificationCenter.defaultCenter().postNotificationName(kUSDAItemCompleted, object: usdaItem)
                            }
                            
                        }
                        
                    }
                }
            }
        }
    }
}