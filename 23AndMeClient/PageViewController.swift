//
//  PageViewController.swift
//  23AndMeClient
//
//  Created by Josh Kahl on 2/17/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

import UIKit

protocol PageController
{
  func createPageViewController()
}

class PageViewController: UIViewController,  UIPageViewControllerDataSource
{
  private let imageContent = ["background0", "background1", "background2", "backgroun3"]
  
  private var pageViewController: UIPageViewController?
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    createPageViewController()
    //setupPageControl()  //
  }
  
  //this method instantiates the PageViewController object - which serves as a controller for all of the individual VC's
  func createPageViewController()
  {
    let pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as UIPageViewController
    pageViewController.dataSource = self
    if (imageContent.count > 0)
    {
      let firstController = getItemController(0)!
      let startingViewControllers: NSArray = [firstController]
      pageViewController.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
    
    addChildViewController(pageViewController)
    self.view.addSubview(pageViewController.view)
    pageViewController.didMoveToParentViewController(self)
  }
  
  private func getItemController(itemIndex: Int) -> PageContentViewController?
  {
    if (itemIndex < imageContent.count)
    {
      let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("Content") as PageContentViewController
      pageItemController.itemIndex = itemIndex
      pageItemController.imageName = self.imageContent[itemIndex]
      
      if (itemIndex == imageContent.count - 1)
      {
        pageItemController.hideButton = false
      } else {
        pageItemController.hideButton = true
      }
      return pageItemController
    }
    return nil
  }
  /*
  private func setupPageControl()
  {
    let appearance = UIPageControl.appearance()
    appearance.backgroundColor = UIColor.greenColor()
  } */
  
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
  {
   let itemController = viewController as PageContentViewController
  
    if (itemController.itemIndex > 0)
    {
      return getItemController(itemController.itemIndex - 1)
    }
    return nil
  }
  
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
  {
    let itemController = viewController as PageContentViewController
    
    if (itemController.itemIndex + 1 < imageContent.count)
    {
      return getItemController(itemController.itemIndex + 1)
    }
    return nil
  }
  
  
  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
  {
    return imageContent.count
  }
  
  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
  {
    return 0
  }
}
