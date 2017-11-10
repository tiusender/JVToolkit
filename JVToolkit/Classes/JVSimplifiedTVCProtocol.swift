//
//  JVSimplifiedTableViewController.swift
//  Pods
//
//  Created by Jorge Villalobos Beato on 12/21/16.
//
//

import Foundation

public protocol JVSimplifiedTVCProtocol {
    associatedtype T
    
    func itemForIndexPath(_ indexPath:IndexPath) -> T?
    func configureCell(_ cell:UITableViewCell, item:T?, indexPath:IndexPath)
    func cellDidDisappear(_ cell:UITableViewCell, indexPath:IndexPath)
}


/*

public extension JVSimplifiedTableViewController where Self: UITableViewController
{
    func customTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, cellIdentifier: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let item = self.itemForIndexPath(indexPath)
        self.configureCell(cell, forItem:item, indexPath: indexPath)
        
        return cell
    }
    
    func customTableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.indexPathsForVisibleRows?.index(of: indexPath) == nil {
            self.cellDidDisappear(cell, indexPath: indexPath)
        }
    }
    
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2//episodes.count
    }*/

