//
//  JVStaticTableVCSection.swift
//  iLoveTv
//
//  Created by Jorge Villalobos Beato on 12/19/16.
//  Copyright © 2016 Jorge Villalobos Beato. All rights reserved.
//

import UIKit

open class JVStaticTableVCSection {
    public var staticRows:[JVStaticTableVCRow] = []
    public var name:String = ""
    
    public init(name:String) {
        self.name = name
    }
    
    public func addRow(cellIdentifier:String? = nil, setupBlock:((_ cell:UITableViewCell)->Void)? = nil, selectionBlock:(()->Void)? = nil) {
        
        self.staticRows.append(JVStaticTableVCRow(cellIdentifier: cellIdentifier, setupBlock: setupBlock, selectionBlock: selectionBlock))
    }
}
