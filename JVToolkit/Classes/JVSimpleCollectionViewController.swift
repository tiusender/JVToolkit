//
//  JVSimpleCollectionViewController.swift
//  Pods
//
//  Created by Jorge Villalobos Beato on 12/21/16.
//
//

import Foundation

open class JVSimpleCollectionViewController: UICollectionViewController, JVSimplifiedCVCProtocol, JVRemotableViewController {
    
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
    
    open func configureCell<T>(_ cell:UICollectionViewCell, item:T?, indexPath:IndexPath) {
        
    }
    
    open func cellDidDisappear(_ cell:UICollectionViewCell, indexPath:IndexPath) {
        
    }
    
    override open func viewDidLoad() {
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        self.cellIdentifier = "cell"
        
        if let collectionView = collectionView {
            self.customViewDidLoad(collectionView)
        }
        
        super.viewDidLoad()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        self.customViewWillDisappear(animated)
        super.viewWillDisappear(animated)
    }

    public func reloadData() {
        self.collectionView?.reloadData()
    }
    
    // MARK: - Collection View Controller cell management
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath)
        let item = self.itemForIndexPath(indexPath)
        self.configureCell(cell, item:item, indexPath: indexPath)
        
        return cell
    }
    
    override open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.indexPathsForVisibleItems.index(of: indexPath) == nil {
            self.cellDidDisappear(cell, indexPath: indexPath)
        }
    }
    
    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return items.count
    }
    
}
