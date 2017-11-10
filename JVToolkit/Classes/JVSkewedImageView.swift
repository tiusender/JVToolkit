//
//  SkewedImageView.swift
//  Pods
//
//  Created by Jorge Villalobos Beato on 12/24/16.
//
//

import Foundation

class JVSkewedImageView:UIView {
    
    public var topLeftCorner = CGPoint()
    public var bottomLeftCorner = CGPoint()
    public var topRightCorner = CGPoint()
    public var bottomRightCorner = CGPoint()
    
    public var imageView:UIImageView?
    
    public init(frame: CGRect, topLeftCorner:CGPoint, bottomLeftCorner:CGPoint, topRightCorner:CGPoint, bottomRightCorner:CGPoint, imageView:UIImageView) {
        
        self.topLeftCorner = topLeftCorner
        self.bottomLeftCorner = bottomLeftCorner
        self.topRightCorner = topRightCorner
        self.bottomRightCorner = bottomRightCorner
        self.imageView = imageView
        
        super.init(frame:frame)
        
        self.isOpaque = false
    }
    
    override func updateConstraints() {
        
        //self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        super.updateConstraints()
    }
    
    override public func layoutSubviews() {        
        //Calculate image frame based on skewed corners.
        let minX = min(topLeftCorner.x, bottomLeftCorner.x)
        let minY = CGFloat(0)
        let maxX = max(topRightCorner.x, bottomRightCorner.x)
        let maxY = frame.height
        
        
        let imageFrame = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        
        self.imageView!.frame = imageFrame
        self.imageView!.contentMode = .scaleAspectFill
        
        self.addSubview(self.imageView!)
        
        //self.backgroundColor = UIColor.red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ frame: CGRect) {
        self.isOpaque = false
        
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: topLeftCorner)
        bezierPath.addLine(to: topRightCorner)
        bezierPath.addLine(to: bottomRightCorner)
        bezierPath.addLine(to: bottomLeftCorner)
        bezierPath.addLine(to: topLeftCorner)
        bezierPath.close()
        
        
        /*
        UIColor.black.setStroke()
        bezierPath.lineWidth = 10
        bezierPath.stroke()
        */
        
        let shape = CAShapeLayer()
        shape.frame = imageView!.bounds
        shape.bounds = imageView!.frame
        shape.path = bezierPath.cgPath
        imageView!.layer.mask = shape
    }
}

