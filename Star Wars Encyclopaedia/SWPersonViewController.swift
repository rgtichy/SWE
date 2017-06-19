//
//  ViewController.swift
//  Star Wars Encyclopaedia
//
//  Created by Robert G Tichy on 5/17/17.
//  Copyright © 2017 Robert G Tichy. All rights reserved.
//

import UIKit

class SWPersonViewController: UITableViewController {
//    var people = ["Luke Skywalker", "Leia Organa", "Han Solo", "C-3PO", "R2-D2"]
    var tableData:NSMutableArray = NSMutableArray()
    var maxCount: Int = 0
    var urlNext: String = ""
    let peopleURL: String = "http://swapi.co/api/people/"

    func getPeople(pageURL: String = "http://swapi.co/api/people/") {
        // specify the url that we will be sending the GET Request to
//        let url = URL(string: "http://swapi.co/api/people/")
        let url = URL(string: pageURL)
        // create a URLSession to handle the request tasks
        let session = URLSession.shared
        // create a "data task" to make the request and run the completion handler
        let task = session.dataTask(with: url!, completionHandler: {
            // see: Swift closure expression syntax
            data, response, error in
            do {
                print("in here")
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    // Why do we need to optionally unwrap jsonResult["results"]
                    // Try it without the optional unwrapping and you'll see that the value is actually an optional
                    print("\n=Start~=~=~=~=~=~=~=~=~=~")
                    print(jsonResult["results"] as Any)
                    self.maxCount = jsonResult["count"] as! Int
                    if jsonResult["next"] != nil && !(jsonResult["next"] is NSNull) {
                        self.urlNext = jsonResult["next"] as! String
                    }
                    else {
                        self.urlNext = ""
                    }
//                    self.urlNext = (jsonResult["next"] as? String)!
                    print("Total People:\(self.maxCount)")
                    print("Next Page:\(self.urlNext)")
                    if let results = jsonResult["results"] {
                        // coercing the results object as an NSArray and then storing that in resultsArray
                        self.tableData.addObjects(from:(results as! [Any]))
                        // now we can run NSArray methods like count and firstObject
                        print(self.tableData.count)
//                        print(self.tableData[0])
                        print("=End  ~=~=~=~=~=~=~=~=~=~\n\n")
//                        print(self.tableData.firstObject!)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            } catch {
                print(error)
            }
            
            // see: Swift nil coalescing operator (double questionmark)
            print(data ?? "no data") // the "no data" is a default value to use if data is nil
        })
        // execute the task and wait for the response before
        // running the completion handler. This is async!
        task.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        getPeople()
 
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // if we return - sections we won't have any sections to put our rows in
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the count of people in our data array
        return tableData.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a cell from identifier and cast it into its matching class
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell") as! personCell
        print("loading: \(indexPath.row) of \(tableData.count)")
        if urlNext != "" && indexPath.row == (tableData.count - 1) && maxCount > tableData.count {
            getPeople(pageURL: urlNext)
        }
        // cell.textLabel?.text = people[indexPath.row]
        let dict = tableData[indexPath.row] as! NSDictionary
        cell.personName.text = dict["name"] as? String
        // return the cell so that it can be rendered
        return cell
    }
}

