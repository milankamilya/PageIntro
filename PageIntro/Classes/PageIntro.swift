//
//  PageIntro.swift
//  octopull
//
//  Created by Milan Kamilya on 23/05/17.
//  Copyright © 2017 Milan Kamilya. All rights reserved.
//

import UIKit
public class PageIntro: UIView {
    
    //MARK:- Public Properties
    public var arrayOfItem: [PageIntroItem]?
    
    //MARK:- Private Properties
    private var outerBezierPath: UIBezierPath?
    private let outerShapeLayer = CAShapeLayer()
    
    private var innerBezierPath: UIBezierPath?
    private let innerMaskLayer = CAShapeLayer()
    
    private var currentItem: Int? = -1

    private let dimColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.25)

    
    let durationForContentView = 0.1
    let durationToMoveCircles = 0.2
    let durationToDisappear = 0.5
    
    //MARK:- Life-cycle Methods
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Initial Setup
    public func setup() {
        
        // TASKS:
        // 1. set background color to clear color
        // 2. set dimingColor
        // 3. Add Tap gesture recognizer to it
        
        backgroundColor = dimColor
        currentItem = 0
        
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(PageIntro.tapGestureRecognized(gesture:)))
        addGestureRecognizer(recognizer)
        
        drawAll()
    }
    
    //MARK:- Draw
    
    private func drawAll() {
        
        guard let arrayOfItem = arrayOfItem else {
            return
        }
        guard let currentItem = currentItem else {
            return
        }
        
        if currentItem < arrayOfItem.count {
            
            let item = arrayOfItem[currentItem]
            outerBezierPath = getOuterBeizerPath(item: item)
            setOuterLayer()
            
            innerBezierPath = getInnerBeizerPath(item: item)
            setInnerLayer()
            
            animateContentViewAppearance(item: item)
            
        }
        
    }
    
    private func setOuterLayer() {
        
        let outerColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
        guard let outerBezierPath = outerBezierPath else {
            return
        }
        
        outerShapeLayer.path = outerBezierPath.cgPath
        outerShapeLayer.fillColor = outerColor.cgColor
        outerShapeLayer.fillRule = kCAFillRuleEvenOdd
        layer.addSublayer(outerShapeLayer)
        
    }
    
    private func setInnerLayer() {
        guard let innerBezierPath = innerBezierPath else {
            return
        }
        
        innerMaskLayer.path = innerBezierPath.cgPath
        innerMaskLayer.fillRule = kCAFillRuleEvenOdd
        layer.mask = innerMaskLayer
    }
    
    private func blurBackground() {
        
        // 1. Take a background pic
        
        /*
         let blurEffect = UIBlurEffect(style: .Light)
         let blurView = UIVisualEffectView(effect: blurEffect)
         super.insertSubview(blurView, atIndex: 0)
         */
    }
    
    //MARK:- Animation
    private func animateToZoom() {
        
        guard let arrayOfItem = arrayOfItem else {
            return
        }
        guard let currentItem = currentItem else {
            return
        }
        
        let isPreviousIndex = arrayOfItem.indices.contains(currentItem)
        
        if isPreviousIndex {
            let previousItem = arrayOfItem[self.currentItem!]
            
            guard let rect = previousItem.rectForCircle else {
                return
            }
            let center = getCenter(rect: rect)
            let (transX, transY) = getDistanceFromCenter(point: center)
            let animation = CABasicAnimation(keyPath: "transform")
            
            animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
            animation.toValue = NSValue(caTransform3D:
                CATransform3DConcat(
                    CATransform3DMakeTranslation(transX, transY, 0.0),
                    CATransform3DMakeScale(150.0, 150.0, 1.0)
                )
            )
            
            animation.duration = durationToDisappear
            animation.beginTime = CACurrentMediaTime() + durationForContentView
            animation.delegate = self
            animation.fillMode = kCAFillModeForwards
            animation.isRemovedOnCompletion = false
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            
            layer.add(animation, forKey: nil)
            
        }
    }
    
    private func animateCircles(fromItem: PageIntroItem, toItem: PageIntroItem) {
        
        let outerInitialPath = getOuterBeizerPath(item: fromItem)
        let outerFinalPath = getOuterBeizerPath(item: toItem)
        let innerInitialPath = getInnerBeizerPath(item: fromItem)
        let innerFinalPath = getInnerBeizerPath(item: toItem)
        
        
        let shapeLayerAnimation = CABasicAnimation(keyPath: "path")
        shapeLayerAnimation.fromValue = outerInitialPath.cgPath
        shapeLayerAnimation.toValue = outerFinalPath.cgPath
        shapeLayerAnimation.duration = durationToMoveCircles
        shapeLayerAnimation.beginTime =  CACurrentMediaTime()
        outerShapeLayer.add(shapeLayerAnimation, forKey: nil)
        outerShapeLayer.path = outerFinalPath.cgPath
        
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = innerInitialPath.cgPath
        maskLayerAnimation.toValue = innerFinalPath.cgPath
        maskLayerAnimation.duration = durationToMoveCircles
        maskLayerAnimation.beginTime =  CACurrentMediaTime()
        innerMaskLayer.add(maskLayerAnimation, forKey: nil)
        innerMaskLayer.path = innerFinalPath.cgPath
    }
    
    private func animateContentViewDisappearance(item: PageIntroItem) {
        
        if let contentView = item.contentView {
            UIView.animate(
                withDuration: durationForContentView,
                delay: 0,
                options: .curveEaseInOut,
                animations: {
                contentView.alpha = 0
            }, completion: { (result) in
                contentView.removeFromSuperview()
            })
        }
    }
    
    private func animateContentViewAppearance(item: PageIntroItem) {
        if let contentView = item.contentView, let rect = item.rectForContentView {
            contentView.frame = rect
            contentView.backgroundColor = UIColor.clear
            contentView.alpha = 0.0
            addSubview(contentView)
            UIView.animate(
                withDuration: durationForContentView,
                delay: durationForContentView,
                options: .curveEaseInOut,
                animations: {
                    contentView.alpha = CGFloat(1)
            }, completion: nil)
            
        }
    }
    
    //MARK:- User Interaction
    func tapGestureRecognized(gesture: UIGestureRecognizer) {
        
        guard let arrayOfItem = arrayOfItem else {
            return
        }
        guard let currentItem = currentItem else {
            return
        }
        
        let isPreviousIndex = arrayOfItem.indices.contains(currentItem)
        let isItemIdex = arrayOfItem.indices.contains(currentItem+1)
        
        if isPreviousIndex && isItemIdex {
            
            let previousItem = arrayOfItem[self.currentItem!]
            self.currentItem! += 1
            let item = arrayOfItem[self.currentItem!]
            
            animateContentViewDisappearance(item: previousItem)
            animateContentViewAppearance(item: item)
            
            animateCircles(fromItem: previousItem, toItem: item)
            
        } else {
            
            if isPreviousIndex {
                let previousItem = arrayOfItem[currentItem]
                animateContentViewDisappearance(item: previousItem)
            }
            animateToZoom()
        }
        
    }
    
    //MARK:- Utility
    
    private func getOuterBeizerPath(item: PageIntroItem) -> UIBezierPath {
        
        let defaultPath = UIBezierPath(rect: bounds)
        guard let rect = item.rectForCircle, let radius = item.outerCircleRadius  else {
            return defaultPath
        }
        return getBeizerPath(rect: rect, radius: radius)
    }
    
    private func getInnerBeizerPath(item: PageIntroItem) -> UIBezierPath {
        
        let defaultPath = UIBezierPath(rect: bounds)
        guard let rect = item.rectForCircle, let radius = item.innerCircleRadius  else {
            return defaultPath
        }
        return getBeizerPath(rect: rect, radius: radius)
    }
    
    private func getBeizerPath(rect: CGRect, radius: CGFloat) -> UIBezierPath {
        
        let cPoint = getCenter(rect: rect)
        let fullAngle = 2.0 * CGFloat(M_PI)
        let beizerPath = UIBezierPath(arcCenter: cPoint,
                                      radius: radius,
                                      startAngle: 0,
                                      endAngle: fullAngle,
                                      clockwise: true)
        beizerPath.append(UIBezierPath(rect: bounds))
        
        return beizerPath
        
    }
    
    private func getCenter(rect: CGRect) -> CGPoint {
        let holeRectIntersection = rect.intersection(frame)
        let cX = holeRectIntersection.origin.x + holeRectIntersection.size.width/2
        let cY = holeRectIntersection.origin.y + holeRectIntersection.size.height/2
        let cPoint = CGPoint(x: cX, y: cY)
        return cPoint
    }
    
    private func getDistanceFromCenter(point: CGPoint) -> (CGFloat, CGFloat) {
        
        let dX = frame.width / 2
        let dY = frame.height / 2
        
        let transX = dX - point.x
        let transY = dY - point.y
        
        return (transX,transY)
        
    }
    
}

//MARK:- 
extension PageIntro : CAAnimationDelegate {
    func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        removeFromSuperview()
    }
}
