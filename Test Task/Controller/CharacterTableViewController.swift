//
//  CharacterTableViewController.swift
//  Test Task
//
//  Created by Данил on 9/11/18.
//  Copyright © 2018 Dareniar. All rights reserved.
//

import UIKit

class CharacterTableViewController: UITableViewController {
    
    var characters: [Character: Int]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = characters?.count {
            return count
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath)
        if let character = characters?.keys.sorted()[indexPath.row] {
            if character == " " {
                cell.textLabel?.text = "\" space \" - \((characters![character])!)"
            } else {
                cell.textLabel?.text = "\" \(character) \" - \((characters![character])!)"
            }
        } else {
            cell.textLabel?.text = ""
        }
        return cell
    }
}
