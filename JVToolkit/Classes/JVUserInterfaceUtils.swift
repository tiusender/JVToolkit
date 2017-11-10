//
//  JVUserInterfaceUtils.swift
//  Pods
//
//  Created by Jorge Villalobos Beato on 11/30/16.
//
//

import Foundation
import UIKit
import AlamofireImage
import PKHUD
//This will have to be included again for Production: import Bond
import SwiftyUserDefaults
import LGRefreshView

public extension DefaultsKeys {
    public static let accountCreated = DefaultsKey<Bool?>("acountCreated")
    public static let notificationsConfigured = DefaultsKey<Bool?>("notificationsConfigured")
    public static let notificationsEnabled = DefaultsKey<Bool?>("notificationsEnabled")
    public static let migrationNeeded = DefaultsKey<Bool?>("migrationNeeded")
    public static let migrationConfigured = DefaultsKey<Bool?>("migrationConfigured")
    public static let migrationCompleted = DefaultsKey<Bool?>("migrationCompleted")
    public static let onboardingCompleted = DefaultsKey<Bool?>("onboardingCompleted")
    public static let userLoggedIn = DefaultsKey<Bool?>("userLoggedIn")
    
    public static let deviceToken = DefaultsKey<String?>("deviceToken")
}

public class JVUserInterfaceUtils {
    
}

//Assigning values
extension JVUserInterfaceUtils {
    public class func assignValueToLabel(_ label:UILabel?, value:String?, defaultValue:String) {
        if let label = label {
            if let value = value {
                label.text = value
            } else {
                label.text = defaultValue
            }
        }
    }
    
    public class func assignValueToLabel(_ label:UILabel?, value:Int?, defaultValue:String) {
        if let label = label {
            if let value = value {
                label.text = String(value)
            } else {
                label.text = defaultValue
            }
        }
    }
}

//Working with remote images and UIImageView
extension JVUserInterfaceUtils {
    public class func loadRemoteImageInImageView(_ urlString:String, imageView:UIImageView, fade:Bool? = true, defaultImage:UIImage? = nil,
                                                 completion:@escaping(_ error:Bool) -> Void) -> Void
    {
        if let defaultImage = defaultImage {
            imageView.image = defaultImage
        }
        
        NLImageLoader.sharedLoader.imageForUrl(urlString, completionHandler:{(image: UIImage?, url: String) in
            
            if let image = image {
                imageView.alpha = 0.0
                imageView.image = image
                
                if let fade = fade , fade == false {
                    imageView.alpha = 1.0
                    completion(false)
                } else {
                    UIView.animate(withDuration: 0.3, animations: {
                        imageView.alpha = 1.0
                        completion(true)
                    })
                }
            } else {
                if let defaultImage = defaultImage {
                    imageView.image = defaultImage
                }
                completion(false)
                //reject(InternalError.Undefined(message: "Image not retrievable"))
            }
        })
    }
    
    public class func lazyImageLoad(_ imageUrlString:String?, imageView:UIImageView?, placeholderImage:UIImage)
    {
        if let imageUrlString = imageUrlString,
            let imageUrl = URL(string: imageUrlString),
            let imageView = imageView
        {
            let filter = AspectScaledToFillSizeFilter(size: imageView.bounds.size)
            
            imageView.af_setImage(withURL: imageUrl,
                                  placeholderImage: placeholderImage,
                                  imageTransition: .crossDissolve(0.2))
        }
        else if let imageView = imageView
        {
            imageView.image = placeholderImage
        }
    }
    
    public class func lazyImageLoadNoFilter(_ imageUrlString:String?, imageView:UIImageView?, placeholderImage:UIImage)
    {
        if let imageUrlString = imageUrlString,
            let imageUrl = URL(string: imageUrlString),
            let imageView = imageView
        {
            imageView.af_setImage(withURL: imageUrl,
                                  placeholderImage: placeholderImage,
                                  imageTransition: .crossDissolve(0.2))
        }
        else if let imageView = imageView
        {
            imageView.image = placeholderImage
        }
    }
}

//View utils
extension JVUserInterfaceUtils {
    public class func saveViewToFile(_ view:UIView, filename:String)
    {
        UIGraphicsBeginImageContext(view.frame.size);
        
        let ctx:CGContext = UIGraphicsGetCurrentContext()!
        UIColor.black.set()
        ctx.fill(view.frame)
        
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let vwImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let data = UIImageJPEGRepresentation(vwImage, 0.8)
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let strPath = documentsPath.appendingPathComponent(filename)
        try? data?.write(to: URL(fileURLWithPath: strPath), options: [.atomic])
    }
}

//Color utils
extension JVUserInterfaceUtils {
    public class func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

//Blurring utils
extension JVUserInterfaceUtils {
    public class func createStaticBlurBackgroundViewForView(_ superview:UIView, name:String) -> UIView
    {
        let blurredBackgroundView = UIView()
        blurredBackgroundView.frame = superview.bounds
        
        let imageView = UIImageView(image: UIImage(named: name))
        imageView.frame = blurredBackgroundView.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurredBackgroundView.addSubview(imageView)
        
        return blurredBackgroundView
    }
    
    public class func createBlurBackgroundViewForView(_ superview:UIView, name:String) -> UIView
    {
        let blurredBackgroundView = UIView()
        blurredBackgroundView.frame = superview.bounds
        
        let imageView = UIImageView(image: UIImage(named: name))
        imageView.frame = blurredBackgroundView.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurredBackgroundView.addSubview(imageView)
        
        let effect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.frame = superview.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurredBackgroundView.addSubview(effectView)
        
        return blurredBackgroundView
    }
    
    public class func createDynamicBlurBackgroundViewForView(_ superview:UIView, urlString:String) -> UIView
    {
        let blurredBackgroundView = UIView()
        blurredBackgroundView.frame = superview.bounds
        
        let imageView = UIImageView()
        imageView.frame = blurredBackgroundView.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurredBackgroundView.addSubview(imageView)
        
        let effect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.frame = blurredBackgroundView.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurredBackgroundView.addSubview(effectView)
        
        //Utils.loadRemoteImageInImageView(urlString, imageView: imageView, fade: false,
        
        //loadRemoteImageInImageView(urlString, imageView:imageView,
        
        JVUserInterfaceUtils.loadRemoteImageInImageView(urlString, imageView:imageView, fade:false, completion:{ (error:Bool) in
            
        })
        
        return blurredBackgroundView
    }
    
    public class func createDynamicBlurBackgroundViewForView(_ superview:UIView, urlString:String, defaultImage:String) -> UIView
    {
        return JVUserInterfaceUtils.createDynamicBlurBackgroundViewForView(superview,
                                                                    urlString: urlString,
                                                                    defaultImage: UIImage(named: defaultImage)!)
    }
    
    public class func createDynamicBlurBackgroundViewForView(_ superview:UIView, urlString:String, defaultImage:UIImage) -> UIView
    {
        let blurredBackgroundView = UIView()
        blurredBackgroundView.frame = superview.bounds
        
        let imageView = UIImageView()
        imageView.frame = blurredBackgroundView.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurredBackgroundView.addSubview(imageView)
        
        let effect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.frame = superview.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurredBackgroundView.addSubview(effectView)
        
        JVUserInterfaceUtils.lazyImageLoad(urlString,
                                           imageView: imageView,
                                           placeholderImage: defaultImage)
        return blurredBackgroundView
    }
}

//Progress HUD management
extension JVUserInterfaceUtils {
    public class func showProgressHUD() {
        JVBaseUtils.executeBlockOnMainThread({ () -> Void in
            PKHUD.sharedHUD.dimsBackground = true
            PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = true
            PKHUD.sharedHUD.contentView = PKHUDProgressView()
            PKHUD.sharedHUD.show()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        })
    }
    
    public class func changeProgressHUDIntoError(_ error:NSError) {
        JVBaseUtils.executeBlockOnMainThread({ () -> Void in
            PKHUD.sharedHUD.contentView = PKHUDTextView(text: "\(error.description)")
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        })
    }
    
    public class func changeProgressHUDIntoSuccess() {
        JVBaseUtils.executeBlockOnMainThread({ () -> Void in
            PKHUD.sharedHUD.contentView = PKHUDSuccessView()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        })
    }
    
    public class func hideProgressHUD()
    {
        JVBaseUtils.executeBlockOnMainThread({ () -> Void in
            PKHUD.sharedHUD.hide(afterDelay: 0.2)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }
    
    public class func showPlainErrorHUD(_ error:Error){
        JVBaseUtils.executeBlockOnMainThread({ () -> Void in
            PKHUD.sharedHUD.dimsBackground = true
            PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = true
            PKHUD.sharedHUD.contentView = PKHUDTextView(text: "\(error.localizedDescription)")
            PKHUD.sharedHUD.show()
            //UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            PKHUD.sharedHUD.hide(afterDelay: 1.0)
            //UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    public class func showErrorHUD(_ error:NSError){
        JVBaseUtils.executeBlockOnMainThread({ () -> Void in
            PKHUD.sharedHUD.dimsBackground = true
            PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = true
            PKHUD.sharedHUD.contentView = PKHUDTextView(text: "\(error.description)")
            PKHUD.sharedHUD.show()
            //UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            PKHUD.sharedHUD.hide(afterDelay: 1.0)
            //UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
}

//Alert view management
extension JVUserInterfaceUtils {
    public class func showSimpleAlertInViewController(_ viewController:UIViewController, title:String, message:String, completion:@escaping ()->Void)
    {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) -> Void in
            
        }))
        viewController.present(alertView, animated: true, completion: completion)
    }
    
    public class func showTextInputAlertInViewController(_ viewController:UIViewController, title:String, message:String, placeHolder:String, defaultTextValue:String?=nil, success:@escaping (String)->Void, cancel:@escaping ()->Void)
    {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (alertAction) -> Void in
            if let inputText:String = alertView.textFields?.first?.text
            {
                let cleanInputText = inputText.trimmingCharacters(in: CharacterSet.whitespaces)
                success(cleanInputText)
            }
            else
            {
                cancel()
            }
        })
        
        okAction.isEnabled = false
        
        alertView.addTextField { (textField) -> Void in
            textField.placeholder = placeHolder
            
            if let defaultTextValue = defaultTextValue {
                textField.text = defaultTextValue
            }
            
            okAction.isEnabled = true
            /*
            textField.bnd_text.observeNext { text in
                
                if (text?.trimmingCharacters(in: CharacterSet.whitespaces).characters.count)! > 0 {
                    okAction.isEnabled = true
                } else {
                    okAction.isEnabled = false
                }
            }*/
        }
        
        alertView.addAction(okAction)
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) -> Void in
            cancel()
        }))
        viewController.present(alertView, animated: true, completion: nil)
    }
}

//Storyboard utilities
extension JVUserInterfaceUtils {
    
    public class func instantiate(viewControllerId:String, storyboardName:String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerId)
        
        return viewController
    }
    
    public class func instantiate(_ viewControllerRef:JVViewControllerRef) -> UIViewController {
        let storyboard = UIStoryboard(name: viewControllerRef.storyboard, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerRef.name)
        
        return viewController
    }
    
    private class func setRootVC(_ window:UIWindow, _ vc:JVViewControllerRef) {
        window.rootViewController = instantiate(viewControllerId: vc.name, storyboardName: vc.storyboard)
    }
    
    public class func appInitLogic(window:UIWindow?,
                                   welcomeVC:JVViewControllerRef, loginVC:JVViewControllerRef,
        loggedHomeVC:JVViewControllerRef, notLoggedHomeVC:JVViewControllerRef, isUserLoggedIn:Bool)
    {
        /*
         - When account is created: AccountCreated = true
         - When Notifications are configured (enabled or not): NotificationsConfigured = true
         - When Migration is needed, MigrationNeeded = true.
         - When Migration is configured (done or not): MigrationConfigured = true
         - When AC + NC + MC = true, OnboardingCompleted = true
         To account for possible app closure after creating and account but before completing the onboarding, when AC = true, OnboardingCompleted = true
         
         - When OC = true, whenever Signs up or Logs in happen, no full on boarding is presented.
         - When presenting settings:
         - If NC = true, don’t display Notifications setting
         - If MC = true or MN = false, don’t display Migration setting
         - LoggedIn = true
         */
        
        if let window = window {
            if Defaults.hasKey(.launchCount) {
                //Not the first time
                if isUserLoggedIn {
                    //User is already logged in, display Logged Home
                    setRootVC(window, loggedHomeVC)
                } else {
                    //User is not logged in, it is not the first time the app opens.
                    setRootVC(window, notLoggedHomeVC)
                    
                    /*
                    //If the user created an account, offer again the login screen.
                    if Defaults.hasKey(.accountCreated) {
                        if let accountCreated = Defaults[.accountCreated], accountCreated == true {
                            //Yes, display login screen
                            setRootVC(window, loginVC)
                        } else {
                            //No, show them the Not Logged home
                            setRootVC(window, notLoggedHomeVC)
                        }
                    } else {
                        //No, show them the Not Logged home
                        setRootVC(window, notLoggedHomeVC)
                    }*/
                }
                
                Defaults[.launchCount]? += 1
                
            } else {
                //First time. Open welcome screen
                setRootVC(window, welcomeVC)
                
                Defaults[.launchCount] = 1
            }
        } else {
            print("Error with window being nil")
        }
    }
    
    public class func appNextStepAfterAuthentication(currentVC:UIViewController,
                                                     notificationsVC:JVViewControllerRef,
                                                     migrationVC:JVViewControllerRef?,
                                                     onboardingCompleteVC:JVViewControllerRef,
                                                     loggedHomeVC:JVViewControllerRef)
    {
        if Defaults.hasKey(.onboardingCompleted) {
            currentVC.present(instantiate(loggedHomeVC), animated: true, completion: nil)
        } else {
            currentVC.present(instantiate(notificationsVC), animated: true, completion: nil)
        }
        
        Defaults[.onboardingCompleted] = true
    }
    
    public class func appNextStepAfterNotifications(currentVC:UIViewController,
                                                    notificationsVC:JVViewControllerRef,
                                                    migrationVC:JVViewControllerRef?,
                                                    onboardingCompleteVC:JVViewControllerRef,
                                                    loggedHomeVC:JVViewControllerRef,
                                                    isOnboarding:Bool)
    {
        Defaults[.notificationsConfigured] = true
        
        if isOnboarding == true {
            if Defaults.hasKey(.migrationNeeded), let migrationVC = migrationVC {
                currentVC.present(instantiate(migrationVC), animated: true, completion: nil)
            } else {
                currentVC.present(instantiate(onboardingCompleteVC), animated: true, completion: nil)
            }
        } else {
            currentVC.dismiss(animated: true, completion: nil)
            //currentVC.navigationController?.popViewController(animated: true)
        }
    }
    
    public class func appNextStepAfterMigration(currentVC:UIViewController,
                                                notificationsVC:JVViewControllerRef,
                                                migrationVC:JVViewControllerRef?,
                                                onboardingCompleteVC:JVViewControllerRef,
                                                loggedHomeVC:JVViewControllerRef,
                                                isOnboarding:Bool)
    {
        Defaults[.migrationConfigured] = true
        
        if isOnboarding == true {
            currentVC.present(instantiate(onboardingCompleteVC), animated: true, completion: nil)
        } else {
            currentVC.dismiss(animated: true, completion: nil)
            //currentVC.navigationController?.popViewController(animated: true)
        }
    }
    
    public class func enableNotifications() {
        UIApplication.shared.registerForRemoteNotifications()
        
        let settings = UIUserNotificationSettings(types: .alert, categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
                
        Defaults[.notificationsEnabled] = true
    }
    
    public class func migrationCompleted() {
        //TODO
        
        Defaults[.migrationCompleted] = true
    }
    
    public class func settingsShouldDisplayNotifications() -> Bool {
        if Defaults.hasKey(.notificationsEnabled) {
            return false
        } else {
            return true
        }
    }
    
    public class func settingsShouldDisplayMigration() -> Bool {
        if Defaults.hasKey(.migrationNeeded) {
            if Defaults.hasKey(.migrationCompleted) {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    public class func resetLaunchCount() -> Void {
        Defaults.remove(.launchCount)
        
        Defaults.remove(.accountCreated)
        Defaults.remove(.notificationsConfigured)
        Defaults.remove(.migrationNeeded)
        Defaults.remove(.migrationConfigured)
        Defaults.remove(.onboardingCompleted)
        Defaults.remove(.userLoggedIn)
        Defaults.remove(.notificationsEnabled)
        Defaults.remove(.migrationCompleted)
        Defaults.remove(.deviceToken)
        
    }
    
    public class func saveDeviceToken(token:String) {
        Defaults[.deviceToken] = token
    }
    
    public class func getDeviceToken() -> String? {
        if let token = Defaults[.deviceToken] {
            return token
        } else {
            return nil
        }
    }
    
    public class func registerAppForNotifications() -> Void {
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    public class func clearNotifications(application: UIApplication) -> Void {
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
    }
}

//Extending UIViewController
extension UIViewController {
    public func showError(_ message:String) {
        JVUserInterfaceUtils.showSimpleAlertInViewController(self, title: "Error", message: message, completion: {
            
        })
    }
}

//Extending UIScollview
extension UIScrollView {
    func addRefreshView(_ withColor:UIColor, refreshBlock:@escaping ((LGRefreshView?) -> Void)) -> LGRefreshView? {
        let refreshView = LGRefreshView(scrollView: self, refreshHandler:refreshBlock)
        
        refreshView?.tintColor = withColor
        
        return refreshView
    }
}

//Extending
extension JVUserInterfaceUtils {
    public class func createViewWithSkewedRemoteImages(_ remoteImages:[String], frame:CGRect) -> UIView? {
        
        let width = Double(frame.width)
        let height = Double(frame.height)
        let view = UIView(frame: frame)
        
        //let view = UIView.init(frame: frame)
        view.backgroundColor = UIColor.clear
        
        let numberImages = Double(remoteImages.count)
        let baseWpoint = width/numberImages
        let amplitude = width/40.0
        var top = 0.0
        var bottom = 0.0
        
        var topPoint = CGPoint()
        var bottomPoint = CGPoint()
        
        var topLeftCorner = CGPoint(x: 0.0, y: 0.0)
        var bottomLeftCorner = CGPoint(x:0.0, y:height)
        var topRightCorner = CGPoint()
        var bottomRightCorner = CGPoint()
        
        var areas:[JVSkewedImageView] = []
        var area:JVSkewedImageView?
        
        for i in 1...Int(numberImages) {
            
            if i != 1 {
                topLeftCorner = topPoint
                bottomLeftCorner = bottomPoint
            }
            
            if i < Int(numberImages) {
                top = baseWpoint * Double(i) + amplitude
                bottom = baseWpoint * Double(i) - amplitude
                
                topPoint = CGPoint(x: top, y: 0.0)
                bottomPoint = CGPoint(x: bottom, y: height)
                
                topRightCorner = topPoint
                bottomRightCorner = bottomPoint
            } else { //i == numberImages
                topRightCorner = CGPoint(x: width, y: 0.0)
                bottomRightCorner = CGPoint(x:width, y:height)
            }
            area = JVSkewedImageView(frame: frame,
                                   topLeftCorner:topLeftCorner,
                                   bottomLeftCorner:bottomLeftCorner,
                                   topRightCorner:topRightCorner,
                                   bottomRightCorner:bottomRightCorner,
                                   imageView:UIImageView())
            areas.append(area!)
            
            JVUserInterfaceUtils.lazyImageLoad(remoteImages[i - 1],
                                               imageView: area?.imageView!,
                                               placeholderImage: JVUserInterfaceUtils.imageWithColor(UIColor.lightGray, size: CGSize(width: width, height: height)))
        }
        
        
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.autoresizesSubviews = true
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = true
    
        
        for area in areas {
            
            
            area.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            area.autoresizesSubviews = true
            area.contentMode = .scaleToFill
            
            area.translatesAutoresizingMaskIntoConstraints = true
            
            
            view.addSubview(area)
            
            //area.autoresizingMask = [
              //  UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            
            
        }
        
        
        
        return view
    }
}

//Extending UITextField
extension UITextField {
    @objc public func clear() {
        self.text = ""
    }
}

extension UITextField {
    public func modifyClearButtonWithImage(image : UIImage) {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x:0, y:0, width:15, height:15)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(self.clear), for: .touchUpInside)
        self.rightView = clearButton
        self.rightViewMode = .whileEditing
    }
}

extension UIColor {
    convenience init(hexString:String) {
        let hexString:String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as String
        let scanner            = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    public func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
}

extension UITextView {
    public func setHTMLFromString(htmlText: String) {
        
        let beforeFont = self.font
        let beforeColor = self.textColor
        
        let modifiedFont = NSString(format:"<span style=\"color:\(self.textColor?.toHexString() ?? "white"); font-family: '-apple-system', 'HelveticaNeue'; font-size: \(self.font!.pointSize)\">%@</span>" as NSString, htmlText) as String
        
        //let paragraph = NSMutableParagraphStyle()
        //paragraph.alignment = .
        //let attributes: [String : Any] = [NSParagraphStyleAttributeName: paragraph]

        
        //process collection values
        let attrStr = try! NSMutableAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        
        
        self.attributedText = attrStr
        
        self.font = beforeFont
        self.textColor = beforeColor
    }
}

extension UILabel {
    public func setHTMLFromString(htmlText: String) {
        
        let beforeFont = self.font
        let beforeColor = self.textColor
        
        let modifiedFont = NSString(format:"<span style=\"color:\(self.textColor.toHexString()); font-family: '-apple-system', 'HelveticaNeue'; font-size: \(self.font!.pointSize)\">%@</span>" as NSString, htmlText) as String
        
        //process collection values
        let attrStr = try! NSMutableAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        self.attributedText = attrStr
        
        self.font = beforeFont
        self.textColor = beforeColor
    }
}
