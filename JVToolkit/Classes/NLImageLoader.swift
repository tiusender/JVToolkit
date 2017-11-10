//
//  ImageLoader.swift
//  extension
//
//  Created by Nate Lyman on 7/5/14.
//  Copyright (c) 2014 NateLyman.com. All rights reserved.
//
import UIKit
import Foundation

class NLImageLoader {
    
    let cache = NSCache<AnyObject, AnyObject>()
    
    class var sharedLoader : NLImageLoader {
        struct Static {
            static let instance : NLImageLoader = NLImageLoader()
        }
        return Static.instance
    }
    
    func imageForUrl(_ urlString: String, completionHandler:@escaping (_ image: UIImage?, _ url: String) -> ()) {
        DispatchQueue.global(qos: .background).async(execute: {()in
            
            let data: Data? = self.cache.object(forKey: urlString as AnyObject) as? Data
            
            if let goodData = data {
                let image = UIImage(data: goodData)
                DispatchQueue.main.async(execute: {() in
                    completionHandler(image, urlString)
                })
                
                return
            }
            
            let downloadTask: URLSessionDataTask = URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
                if (error != nil) {
                    completionHandler(nil, urlString)
                    return
                }
                
                if let data = data {
                    let image = UIImage(data: data)
                    self.cache.setObject(data as AnyObject, forKey: urlString as AnyObject)
                    DispatchQueue.main.async(execute: {() in
                        completionHandler(image, urlString)
                    })
                    
                    return
                }
                
            } )
            downloadTask.resume()
            
        })
        
    }
}
