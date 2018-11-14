//
//  PageController.swift
//  HookahPlaces
//
//  Created by Евгений on 11/11/2018.
//  Copyright © 2018 Momotov. All rights reserved.
//

import UIKit

class PageController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedInstance.requestAuth()
        self.delegate = self
        self.dataSource = self
        self.view.backgroundColor = UIColor.white
        let controller = storyboard?.instantiateViewController(withIdentifier: "placesController") as! PlacesController
        controller.isSort = TypeSorted.rating
        setViewControllers([controller], direction: .forward, animated: true, completion: nil)
        configBackBarButtonItem()
        LocationManager.sharedInstance.startUpdateLocation()
    }

}

extension PageController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard (viewController as! PlacesController).isSort == TypeSorted.distance else {
            return nil
        }
        let controller = storyboard?.instantiateViewController(withIdentifier: "placesController") as! PlacesController
        controller.isSort = TypeSorted.rating
        return controller
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard (viewController as! PlacesController).isSort == TypeSorted.rating else {
            return nil
        }
        let controller = storyboard?.instantiateViewController(withIdentifier: "placesController") as! PlacesController
        controller.isSort = TypeSorted.distance
        return controller
    }
    
}
