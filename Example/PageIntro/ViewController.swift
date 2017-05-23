//
//  ViewController.swift
//  PageIntro
//
//  Created by Milan Kamilya on 23/05/17.
//  Copyright © 2017 Milan Kamilya. All rights reserved.
//

import UIKit
import PageIntro
class ViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var tabbar: UITabBar!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayPageIntro()
    }
    
    
    private func displayPageIntro() {
        //Add Page Intro
        /// There are two components for each Page Intro Item. 
        /// 1. Circle that focus on the menu,
        /// 2. Content i.e. arrow and text.
        let pageIntro = PageIntro(frame: view.bounds)
        var arrOfRectForCircle = [CGRect]()
        
        let defaultSizeOfCircle = CGSize(width: 90, height: 90)
        let origin = CGPoint(x: menuButton.frame.origin.x - 20, y: menuButton.frame.origin.y-20.0)
        let menuButtonCircleRect = CGRect(origin: origin, size: defaultSizeOfCircle)
        arrOfRectForCircle.append(menuButtonCircleRect)
        
        let widthOfEachTabbarItem = tabbar.frame.size.width / CGFloat(tabbar.items!.count)
        for (index,_) in (tabbar.items?.enumerated())! {
            let point = CGPoint(x: CGFloat(index) * widthOfEachTabbarItem - 15.0, y: tabbar.frame.origin.y)
            let tabbarItemCircleRect = CGRect(origin: point, size: defaultSizeOfCircle)
            arrOfRectForCircle.append(tabbarItemCircleRect)
        }
        
        
        var arrOfPageIntroItem = [PageIntroItem]()
        for (index,cirRect) in arrOfRectForCircle.enumerated() {
            let item = PageIntroItem()
            item.rectForCircle = cirRect
            
            if index == 0 {
                item.rectForContentView = CGRect(x: 65, y:55, width: 200, height: 100)
            } else {
                item.rectForContentView = CGRect(x: view.center.x - 75, y:view.center.y - 50, width: 150, height: 100)
            }
            
            if let v = Bundle.main.loadNibNamed("PageIntro\(index+1)", owner: self, options: nil)?.first as? UIView {
                item.contentView = v
            }
            
            arrOfPageIntroItem.append(item)
        }
        
        pageIntro.arrayOfItem = arrOfPageIntroItem
        pageIntro.setup()
        view.addSubview(pageIntro)
    }
}

