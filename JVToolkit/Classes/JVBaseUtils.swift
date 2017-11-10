//
//  JVBaseUtils.swift
//  Pods
//
//  Created by Jorge Villalobos Beato on 11/30/16.
//
//

import Foundation
import SwiftyUserDefaults

public extension DefaultsKeys {
    public static let localDebug = DefaultsKey<Bool?>("localDebug")
    public static let launchCount = DefaultsKey<Int?>("launchCount")
    public static let userSelectedToCreateAccount = DefaultsKey<Bool?>("userSelectedToCreateAccount")
}


public class JVBaseUtils {
    public static let sharedInstance : JVBaseUtils = JVBaseUtils()
    
    public func currentTimezone() -> String {
        return TimeZone.current.identifier
    }
    
    public func currentDate() -> String {
        return Date(timeIntervalSinceNow: 0).toFormat(format: "yyyy-MM-dd", localTimeZone: true)
    }
}

//Useful protocols
protocol UIViewControllerLoading {
    func controllerDidFinishLoading(_ viewController:UIViewController)
}

public protocol JVInjectable {
    associatedtype T
    func inject(_: T)
    func assertDependencies()
}

public protocol JVPickable {
    func pick(items:[AnyObject]) -> Void
    func setPicking(_ value:Bool) -> Void
}

public protocol JVPickingDelegate {
    func didPickElement(_ element:AnyObject) -> Void
    func didCancelPicking() -> Void
}

public protocol JVEditingDelegate {
    associatedtype T
    func didEndEditing(_ settings:[T]) -> Void
    func didCancelEditing() -> Void
}

public protocol JVBackwardsNotifier {
    associatedtype T
    func notify(_:T) -> Void
}

public protocol JVBackwardsNotifierDelegate {
    associatedtype T
    func receiveNotification<T>(item:T) -> Void
}

public protocol JVModalDelegate {
    func modalDidSucceded(result:Any)
    func modalDidError(error:Any)
    func modalDidCancel()
    
}


//Threads
extension JVBaseUtils {
    public class func executeBlockOnMainThread(_ block:@escaping ()->Void) -> Void {
        DispatchQueue.main.async { () -> Void in
            block()
        }
    }
}

//String utils
extension String {
    public func escape() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
    public func length() -> Int {
        return self.characters.count
    }
    
    public static func string(withNumber:Int, andLength:Int) -> String {
        let str = String(withNumber)
        var finalStr = String()
        
        if andLength > str.characters.count {
            for _ in str.characters.count..<andLength {
                finalStr.append("0" as Character)
            }
        }
        finalStr.append(str)
        
        return finalStr
    }
    
    public func toDate(format:String? = "yyyy-MM-dd", localTimeZone:Bool? = false) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format!
        
        if let localTimeZone = localTimeZone, localTimeZone == true {
            dateFormatter.timeZone = TimeZone.current
        } else {
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
        }
        
        return dateFormatter.date(from: self.replacingOccurrences(of: "T", with: " "))
    }
}


//Date utils
extension Date {
    public static func timestamp() -> TimeInterval {
        return Date().timeIntervalSince1970
    }
    
    public func toFormat(format:String? = "yyyy-MM-dd", localTimeZone:Bool? = false) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format!
        
        if let localTimeZone = localTimeZone, localTimeZone == true {
            dateFormatter.timeZone = TimeZone.current
        } else {
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
        }
        
        return dateFormatter.string(from: self)
    }
}

//Error utils
extension NSError {
    public static func error(withText:String, domain:String? = "No domain", code:Int? = -1) -> NSError
    {
        var dict = [String: AnyObject]()
        dict[NSLocalizedDescriptionKey] = withText as AnyObject?
        
        return NSError(domain: domain!, code: code!, userInfo: dict)
    }
}

//Debugging
extension JVBaseUtils {
    public static func setLocalDebug(_ value:Bool) {
        if value == true {
            Defaults[.localDebug] = true
        } else {
            Defaults.remove(.localDebug)
        }
    }
}

//AutoLayout
extension UIView {
    public func removeAllConstraints() {
        self.removeConstraints(self.constraints)
        for view in self.subviews {
            view.removeAllConstraints()
        }
    }
}
