//
//  JVPageViewController.swift
//  Pods
//
//  Created by Jorge Villalobos Beato on 12/10/16.
//  Copyright © 2016 Jorge Villalobos Beato. All rights reserved.
//

import UIKit

open class JVPageViewController : UIPageViewController {
    
    public var orderedViewControllers: [UIViewController] = []
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        dataSource = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
}

extension JVPageViewController: UIPageViewControllerDataSource {
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.index(of:firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllersCount > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    open func addVC(viewControllerId:String, storyboardName:String){
        orderedViewControllers.append(JVUserInterfaceUtils.instantiate(viewControllerId: viewControllerId, storyboardName: storyboardName))
    }
    
}

