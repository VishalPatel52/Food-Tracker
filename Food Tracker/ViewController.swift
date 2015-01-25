//
//  ViewController.swift
//  Food Tracker
//
//  Created by Vishal Patel on 22/01/15.
//  Copyright (c) 2015 Vishal Patel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    
    let kAppId = "b6cf9193"
    let kAppKey = "2cd0d3a56dc01fce7233d0a748ed579a"
    
    var searchController: UISearchController!
    
    var suggestedSearchFoods:[String] = []
    var filteredSuggestedSearchFoods: [String] = []
    
    var scopeButtonTitles: [String] = ["Recommended", "Search Results", "Saved"]
    
    var jsonResponse:NSDictionary!
    var apiSearchForFoods:[(name: String, idValue: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Mark - setting up the searchController in TableView
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.hidesNavigationBarDuringPresentation = false
        
        
        // Mark - Setting up the searchBar in searchController
        
        self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.width, 44.0)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.scopeButtonTitles = scopeButtonTitles
        self.searchController.searchBar.delegate = self
        self.definesPresentationContext = true
        
        //Initialize the suggestedSearchFoods array with default foods
        self.suggestedSearchFoods = ["apple", "bagel", "banana", "beer", "bread", "carrots", "cheddar cheese", "chicen breast", "chili with beans", "chocolate chip cookie", "coffee", "cola", "corn", "egg", "graham cracker", "granola bar", "green beans", "ground beef patty", "hot dog", "ice cream", "jelly doughnut", "ketchup", "milk", "mixed nuts", "mustard", "oatmeal", "orange juice", "peanut butter", "pizza", "pork chop", "potato", "potato chips", "pretzels", "raisins", "ranch salad dressing", "red wine", "rice", "salsa", "shrimp", "spaghetti", "spaghetti sauce", "tuna", "white wine", "yellow cake"]
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
        if selectedScopeButtonIndex == 0{
            if self.searchController.active {
                if self.searchController.searchBar.text.isEmpty{
                    return self.suggestedSearchFoods.count
                }
                else{
                    return self.filteredSuggestedSearchFoods.count
                    
                }
            }
            else {
                return self.suggestedSearchFoods.count
            }
            
        }
        else if selectedScopeButtonIndex == 1{
            return self.apiSearchForFoods.count
        }
        else {
            return 0
        }
        
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        var foodName : String
        let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
        if selectedScopeButtonIndex == 0 {
            if self.searchController.active {
                if self.searchController.searchBar.text.isEmpty {
                    foodName = self.suggestedSearchFoods[indexPath.row]
                    
                }
                else{
                    foodName = filteredSuggestedSearchFoods[indexPath.row]
                }
            }
            else {
                foodName = suggestedSearchFoods[indexPath.row]
            }
        }
        else if selectedScopeButtonIndex == 1{
            foodName = self.apiSearchForFoods[indexPath.row].name
        }
        else {
            foodName = ""
        }
        
        cell.textLabel?.text = foodName
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
        
    }
    
    // Mark - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
        
        if selectedScopeButtonIndex == 0 {
            var searchFoodName : String
            
            if self.searchController.active {
                searchFoodName = self.filteredSuggestedSearchFoods[indexPath.row]
            }
            else {
                searchFoodName = self.suggestedSearchFoods[indexPath.row]
            }
            self.searchController.searchBar.selectedScopeButtonIndex = 1
            self.makeRequest(searchFoodName)
            
        }
        else if selectedScopeButtonIndex == 1 {
            
        }
        else if selectedScopeButtonIndex == 2 {
            
        }
    }
    
    // Mark - UISearchResultsUpdating Delegate
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        let searchString = self.searchController.searchBar.text
        let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
        
        self.filterContentForSearch(searchString, scope: selectedScopeButtonIndex)
        
        self.tableView.reloadData()
        
        
    }
    
    // Helper function to filter suggestedSearchFoods array
    
    func filterContentForSearch (searchText: String, scope: Int) {
        self.filteredSuggestedSearchFoods = self.suggestedSearchFoods.filter({ (food: String) -> Bool in
            var foodMatch = food.rangeOfString(searchText)
            return foodMatch != nil
        })
    }
    
    
    // Mark - UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchController.searchBar.selectedScopeButtonIndex = 1
        makeRequest(searchBar.text)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchController.searchBar.selectedScopeButtonIndex = 0
    }
    // Mark - API MakeRequest
    
    func makeRequest (searchString: String) {
        
        //*********** How to make HTTP Get Request, see below code: ******************
        
        //        let url = NSURL(string: "https://api.nutritionix.com/v1_1/search/\(searchString)?results=0%3A20&cal_min=0&cal_max=50000&fields=item_name%2Cbrand_name%2Citem_id%2Cbrand_id&appId=\(kAppId)&appKey=\(kAppKey)")
        //        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
        //            var stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
        //            println(stringData)
        //            println(response)
        //        })
        //
        //        task.resume()
        
        //************** END **********************************************************
        
        //************** How to make HTTP Post Request **********************************
        
        let url = NSURL(string: "https://api.nutritionix.com/v1_1/search/")!
        var request = NSMutableURLRequest(URL: url)
        
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = [
            "appId"     : kAppId,
            "appKey"    : kAppKey,
            "fields"    : ["item_name", "brand_name", "keywords", "usda_fields"],
            "limit"     : "50",
            "query"     : searchString,
            "filters"   : ["exists": ["usda_fields":true]]]
        
        var error : NSError?
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &error)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, err) -> Void in
            
            //convert data in to human readable strings
            var conversionError : NSError?
            var jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: &conversionError) as? NSDictionary
            
            println(jsonDictionary)
            
            //Error Handlig
            if conversionError != nil {
                println(conversionError!.localizedDescription)
                var errorString = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error in parsing : \(errorString)")
            }
            else {
                if jsonDictionary != nil {
                    self.jsonResponse = jsonDictionary!
                    self.apiSearchForFoods = DataController.jsonAsUSDAIdAndNameSearchResults(jsonDictionary!)
                    
                    //updating tableview with searchresults with multitreading
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                }
                else {
                    var errorString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON \(errorString)")
                }
            }
        })
        task.resume()
    }
}

