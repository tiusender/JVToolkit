//
//  JVSimplifiedCVCProtocol.swift
//  Pods
//
//  Created by Jorge Villalobos Beato on 12/21/16.
//
//

import Foundation

public protocol JVSimplifiedCVCProtocol {
    associatedtype T
    
    func itemForIndexPath(_ indexPath:IndexPath) -> T?
    func configureCell(_ cell:UICollectionViewCell, item:T?, indexPath:IndexPath)
    func cellDidDisappear(_ cell:UICollectionViewCell, indexPath:IndexPath)
}
