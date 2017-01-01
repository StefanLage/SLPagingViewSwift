//
//  TableViewController.swift
//  TwitterLike
//
//  Created by Bari Levi on 04/12/2016.
//  Copyright © 2016 Stefan Lage. All rights reserved.
//

import Foundation
import UIKit

public class TableViewController: UITableViewController
{
    var dataSource: [String]!
    
    
    
    override init(style: UITableViewStyle) {
        super.init(style: .plain)
        self.view.frame = CGRect(x:0, y:0, width:320, height:568)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.scrollsToTop = false
        
        self.dataSource = ["Hello world!", "Shaqtin' a fool!", "YEAHHH!",
                           "Hello world!", "Shaqtin' a fool!", "YEAHHH!",
                           "Hello world!", "Shaqtin' a fool!", "YEAHHH!",
                           "Hello world!", "Shaqtin' a fool!", "YEAHHH!",
                           "Hello world!", "Shaqtin' a fool!", "YEAHHH!"]
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - UITableView DataSource
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.dataSource.count
    }
    
    override public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cellIdentifier"
        
        var cell = tableView.dequeueReusableCell(withIdentifier:cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
            cell?.textLabel?.numberOfLines = 0
        }
        cell!.imageView?.image = UIImage(named: "avatar_\(indexPath.row % 3).png")
        cell!.textLabel!.text = self.dataSource[indexPath.row]
        
        return cell!
    }

}
