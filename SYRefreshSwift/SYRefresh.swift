//
//  SYRefresh.swift
//  SYRefreshSwift
//
//  Created by reesun on 2017/1/6.
//  Copyright © 2017年 SY. All rights reserved.
//

import UIKit

/** 刷新状态 */
public enum SYRefreshState : NSInteger {
    case ready /**准备松开*/
    case pulling /**拖动中*/
    case refreshing /**刷新中*/
    case end /**结束*/
}

public class SYRefresh: UIControl {
    private let kRefreshHeight : CGFloat = 60.0
    private let kRefreshContentOffset : String = "contentOffset"

    private var titleLabel : UILabel!
    private var activityIndicator : UIActivityIndicatorView!
    private var arrowImageView : UIImageView!
    private var imagePulling : UIImage!
    private var refreshState : SYRefreshState!
    
    //public属性
    public var ready : String!
    public var pulling : String!
    public var refreshing : String!

    public init(scrollView : UIScrollView!) {
        super.init(frame : CGRect.init(x: 0.0, y: -kRefreshHeight - scrollView.contentInset.top, width: scrollView.frame.width, height: kRefreshHeight))
        
        self.initializeDefaultProperties()
        self.initializeSubviews()
        
        scrollView.addSubview(self)
        scrollView.addObserver(self, forKeyPath: kRefreshContentOffset, options: NSKeyValueObservingOptions.old, context: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //public方法
    public func beginRefreshing() -> Void {
        self.setRefreshState(state: .refreshing)
    }
    
    public func endRefreshing() -> Void {
        self.setRefreshState(state: .end)
    }
    
    public func setImagePulling(imagePull:UIImage!) -> Void {
        imagePulling = imagePull
        arrowImageView.image = imagePulling
    }
    
    public func isRefreshing() -> Bool {
        return refreshState == .refreshing
    }

    //private方法
    private func initializeDefaultProperties() -> Void {
        let podBundle = Bundle.init(for: SYRefresh.self)
        let bundle = Bundle.init(url: podBundle.url(forResource: "SYRefresh", withExtension: "bundle")!)

        imagePulling = UIImage.init(named: "arrowDown", in: bundle, compatibleWith: nil)
        refreshState = .end
        ready = "松开立即刷新"
        refreshing = "努力刷新中…"
        pulling = "下拉即可刷新"
        self.backgroundColor = UIColor.clear
    }
    
    private func initializeSubviews() -> Void {
        let arrowHeight : CGFloat = 12.0
        let arrowWidth : CGFloat = imagePulling.size.width * arrowHeight / imagePulling.size.height
        
        arrowImageView = UIImageView.init(frame: CGRect(x: (self.bounds.width - arrowWidth) / 2.0, y: (self.bounds.height - arrowHeight - 25.0) / 2.0, width: arrowWidth, height: arrowHeight))
        arrowImageView.image = imagePulling
        self.addSubview(arrowImageView)
        
        let titleHeight : CGFloat = 25.0
        
        titleLabel = UILabel.init(frame: CGRect(x: 0.0, y: self.bounds.maxY - titleHeight, width: self.bounds.width, height: titleHeight))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor(white: 0.5, alpha: 1.0)
        self.addSubview(titleLabel)
        
        activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = arrowImageView.center
        self.addSubview(activityIndicator)
    }
    
    private func setRefreshState(state : SYRefreshState!) -> Void {
        refreshState = state

        if refreshState == .end {
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 0.0
                self.arrowImageView.layer.transform = CATransform3DIdentity
            }, completion: { (finished) in
                self.activityIndicator.stopAnimating()
            })
        }
        else if refreshState == .pulling {
            titleLabel.text = pulling;
            
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 1.0
                self.titleLabel.alpha = 1.0
                self.arrowImageView.alpha = 1.0
                self.arrowImageView.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
        else if refreshState == .ready {
            titleLabel.text = ready;
            
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 1.0
                self.titleLabel.alpha = 1.0
                self.arrowImageView.alpha = 1.0
                self.arrowImageView.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI), 0.0, 0.0, 1.0)
            }, completion: nil)
        }
        else if refreshState == .refreshing {
            titleLabel.text = refreshing
            activityIndicator.startAnimating()
            
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 1.0
                self.arrowImageView.alpha = 0.0
            }, completion: nil)
        }
        
        //默认额外滚动区域是当前下拉的区域
        var contentInset : UIEdgeInsets = UIEdgeInsets.zero
        
        //刷新时额外滚动区域加大以显示出状态
        if refreshState == .refreshing {
            contentInset.top = self.bounds.height
        }
        else {
            activityIndicator.stopAnimating()
        }
        
        //如果不是scrollview直接返回
        if self.superview is UIScrollView {
            //调整scrollview的额外滚动区域，刷新完毕要调回初始状态，刷新时额外滚动区域加大以显示出状态
            let scrollView = self.superview as! UIScrollView
            
            if (!UIEdgeInsetsEqualToEdgeInsets(scrollView.contentInset, contentInset)) {
                UIView.animate(withDuration: 0.2, animations: {
                    scrollView.contentInset = contentInset
                })
            }
        }
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //不满足我们的条件，这几条直接返回
        if keyPath == nil || keyPath != kRefreshContentOffset || change == nil || change?[NSKeyValueChangeKey.oldKey] == nil {
            return
        }
        
        if (self.superview is UIScrollView || self.superview is UITableView) {
            let scrollview = self.superview as! UIScrollView
            let pullingHeight = -scrollview.contentOffset.y
            
            let oldkey = change?[NSKeyValueChangeKey.oldKey] as! CGPoint
            let previousPullingHeight = -oldkey.y
            
            //print(pullingHeight)
            //print(previousPullingHeight)

            //首先判断是否刷新中以保持刷新状态
            if self.refreshState == .refreshing {
                scrollview.contentInset = UIEdgeInsetsMake(self.bounds.height, scrollview.contentInset.left, scrollview.contentInset.bottom, scrollview.contentInset.right)
            }
            //下拉不小于kRefreshHeight是刷新动画的必要条件
            else if (pullingHeight >= kRefreshHeight || (pullingHeight > 0.0 && previousPullingHeight >= kRefreshHeight)) {
                //不松开手指就是拖动中
                if (scrollview.isDragging) {
                    self.setRefreshState(state: .ready)
                }
                //松开之后就是刷新动画
                else {
                    self.setRefreshState(state: .refreshing)
                    self.sendActions(for: .valueChanged)
                }
            }
            //下拉悬停在0-kRefreshHeight就是拖拽中
            else if (!scrollview.isDecelerating && pullingHeight > 0.0) {
                self.setRefreshState(state: .pulling)
            }
            else {
                self.setRefreshState(state: .end)
            }
        }
    }

    //移除观察者
    deinit {
        self.removeObserver(self, forKeyPath: kRefreshContentOffset)
    }
}
