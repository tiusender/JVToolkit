//
//  JVStaticTableVCRow.swift
//  iLoveTv
//
//  Created by Jorge Villalobos Beato on 12/19/16.
//  Copyright © 2016 Jorge Villalobos Beato. All rights reserved.
//

import UIKit

open class JVStaticTableVCRow {
    public var cellIdentifier:String = ""
    
    public var setupBlock:((_ cell:UITableViewCell)->Void)? = nil
    public var selectionBlock:(()->Void)? = nil
    
    public init(cellIdentifier:String? = nil, setupBlock:((_ cell:UITableViewCell)->Void)? = nil, selectionBlock:(()->Void)? = nil) {
        if let cellIdentifier = cellIdentifier {
            self.cellIdentifier = cellIdentifier
        }
        
        if let setupBlock = setupBlock {
            self.setupBlock = setupBlock
        }
        
        if let selectionBlock = selectionBlock {
            self.selectionBlock = selectionBlock
        }
    }
}
