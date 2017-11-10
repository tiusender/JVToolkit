//
//  JVRemotableViewController.swift
//  Pods
//
//  Created by Jorge Villalobos Beato on 12/19/16.
//
//

import UIKit
import LGRefreshView

public enum RemoteError:Error{
    case unimplemented
}

public protocol JVRemotableViewController {
    var useRefreshControl:Bool {get set}
    
    func reloadData()
    func fetchRemoteData(_ completion:@escaping (_ result:JVResult<Any>) -> Void)
}

public extension JVRemotableViewController where Self: UIViewController
{
    public func internalFetchRemoteData(_ showHUD:Bool)
    {
        JVBaseUtils.executeBlockOnMainThread({ () -> Void in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        })
        
        if showHUD {
            JVUserInterfaceUtils.showProgressHUD()
        }
        
        self.fetchRemoteData { (result:JVResult<Any>) in
            if let error = result.error() {
                //self.refreshView?.endRefreshing()
                if showHUD {
                    JVUserInterfaceUtils.changeProgressHUDIntoError(NSError.error(withText: result.description))
                    JVUserInterfaceUtils.hideProgressHUD()
                } else {
                    JVUserInterfaceUtils.showErrorHUD(NSError.error(withText: result.description))
                }
                
                JVBaseUtils.executeBlockOnMainThread({ () -> Void in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                })
            } else {
                JVBaseUtils.executeBlockOnMainThread({ () -> Void in
                    self.reloadData()
                    
                    if showHUD {
                        JVUserInterfaceUtils.hideProgressHUD()
                    }
                    //self.refreshView?.endRefreshing()
                    JVBaseUtils.executeBlockOnMainThread({ () -> Void in
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    })
                })
            }
        }
    }
    
    public func fetchRemoteDataFromRefresh() {
        self.internalFetchRemoteData(false)
    }

    open func customViewDidLoad(_ mainView:UIView) {
        self.internalFetchRemoteData(true)
        
        if self.useRefreshControl {
            if let theScrollView = mainView as? UIScrollView {
                //self.refreshView =
                theScrollView.addRefreshView(.yellow, refreshBlock: { (refreshView) in
                    self.internalFetchRemoteData(false)
                    refreshView?.endRefreshing()
                })
            }
        }
    }
    
    public func customViewWillDisappear(_ animated: Bool) {
        JVUserInterfaceUtils.hideProgressHUD()
    }
}
