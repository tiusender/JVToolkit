//
//  JVStaticTableVC.swift
//  iLoveTv
//
//  Created by Jorge Villalobos Beato on 12/19/16.
//  Copyright © 2016 Jorge Villalobos Beato. All rights reserved.
//

import UIKit

open class JVStaticTableVC:UITableViewController {
    public var staticSections:[JVStaticTableVCSection] = []
    
    public func addSection(name:String) -> JVStaticTableVCSection {
        let section = JVStaticTableVCSection(name: name)
        staticSections.append(section)
        return section
    }
    
    open func loadSections() {
    }
    
    public func reloadTable() {
        staticSections.removeAll()
        loadSections()
        self.tableView.reloadData()
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staticSections[section].staticRows.count
    }
    
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return staticSections.count
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let staticRow = staticSections[indexPath.section].staticRows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: staticRow.cellIdentifier, for: indexPath)
        
        //Now we call the customization block on the row
        if let setupBlock = staticRow.setupBlock {
            setupBlock(cell)
        }
        
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let staticRow = staticSections[indexPath.section].staticRows[indexPath.row]
        
        //Now we trigger the selection block
        if let selectionBlock = staticRow.selectionBlock {
            selectionBlock()
        }
    }
    
    override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return staticSections[section].name
    }
}
