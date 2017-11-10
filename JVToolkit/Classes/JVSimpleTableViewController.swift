//
//  JVSimpleTableViewController.swift
//  Pods
//
//  Created by Jorge Villalobos Beato on 12/21/16.
//
//

import Foundation

open class JVSimpleTableViewController: UITableViewController, JVSimplifiedTVCProtocol, JVRemotableViewController {
    
    open func fetchRemoteData(_ completion: @escaping (JVResult<Any>) -> Void) {
        completion(JVResult.Failure(RemoteError.unimplemented))
    }
    
    public typealias T = Any
    
    public var useRefreshControl: Bool = true
    
    public var items:[T] = []
    open var cellIdentifier:String = ""
    
    public func itemForIndexPath(_ indexPath:IndexPath) -> T? {
        if items.count > indexPath.row {
            return items[indexPath.row] as T
        } else {
            return nil
        }
    }
    
    open func configureCell<T>(_ cell:UITableViewCell, item:T?, indexPath:IndexPath) {
        
    }
    
    open func cellDidDisappear(_ cell:UITableViewCell, indexPath:IndexPath) {
        
    }
    
    override open func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.cellIdentifier = "cell"
        self.customViewDidLoad(self.tableView)
        
        super.viewDidLoad()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        self.customViewWillDisappear(animated)
        super.viewWillDisappear(animated)
    }
    
    public func reloadData() {
        self.tableView.reloadData()
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let item = self.itemForIndexPath(indexPath)
        self.configureCell(cell, item:item, indexPath: indexPath)
        
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.indexPathsForVisibleRows?.index(of: indexPath) == nil {
            self.cellDidDisappear(cell, indexPath: indexPath)
        }
    }
    
    
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}
