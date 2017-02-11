//
//  ViewController.swift
//  Nutrients
//
//  Created by Kaanugovi, Sudheendra Kumar on 2/10/17.
//  Copyright © 2017 Kaanugovi, Sudheendra Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    // Empty Data Source
    var dataSource: [String] = []

    // When view did appear on screen
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Create a URL object with string, and guard
        guard let url = URL(string: "http://localhost:8080/listofnutrients") else {
            return
        }

        // Create a request object with url just created
        let request = URLRequest(url: url)

        // Get a task from URLSession and initialize with request 
        // and completion that needs to execute once data task is finished.
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check if there was a error
            if error != nil {
                print(error!.localizedDescription)
            } else {
                // No error, happy path, try to convert RAW data to JSON
                do {
                    // check if data exists, try to serialize to a dictionay object
                    if let jsondata = data,
                        let json = try JSONSerialization.jsonObject(with: jsondata, options: .allowFragments) as? [String: Any] {
                        // We have dictionary by now, check and extract the nutrients names as array of strings.
                        if let serverData = json["nutrients"] as? [String] {
                            // update the data source
                            self.dataSource = serverData
                            // Execute on main thread as this is a async call, that executes on a background thread.
                            DispatchQueue.main.async {
                                // We get data later than the table view is initialized in the screen
                                // Tell tableview to reload itself.
                                self.tableView.reloadData()
                            }
                        }
                    }
                } catch {
                    print("error in JSONSerialization")
                }
            }
        }

        task.resume()
    }

    // MARK:- UITableViewDataSource
    // Return number of rows we need to display
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    // For each entry in dataSource, create a tableviewcell and set the text property
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a new table view cell, with default cell style with a label and optional image
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        // Set the text property from dataSource
        cell.textLabel?.text = dataSource[indexPath.row]
        // return configured cell
        return cell
    }
}

