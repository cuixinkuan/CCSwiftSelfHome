//
//  ViewController.swift
//  CCSwiftSelfHome
//
//  Created by admin on 16/5/24.
//  Copyright © 2016年 CuiXinKuan. All rights reserved.
//

import UIKit

// Swift关于可选链 ？和！(optional类型)，参考http://blog.csdn.net/woaifen3344/article/details/30244201
class ViewController: UIViewController,UIScrollViewDelegate {

    var navView:UIToolbar?
    var bacScrollView:UIScrollView!
    let KWidth = UIScreen.mainScreen().bounds.size.width
    let KHeight = UIScreen.mainScreen().bounds.size.height
    var arrs = ["资料","设置","更多"]
    var toorView:UIView!
    var toorViewH:UIToolbar!
    var scrollLineView:UIView!
    var scrollLineViewH:UIView!
    var firstVC:OneViewController?
    var secondVC:TwoViewController?
    var threeVC:ThreeViewController?
    var isScroll:Bool = true
    var oldF:CGFloat = 0.0
    var orginW:CGFloat = UIScreen.mainScreen().bounds.size.width/7
    var s:NSInteger = 0
    
    deinit {
        firstVC?.removeObserver(self, forKeyPath: "offerY")
        secondVC?.removeObserver(self, forKeyPath: "offerY")
        threeVC?.removeObserver(self, forKeyPath: "offerY")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navTitleView()
        self.addController()
        self.addButton()
        
        let vc:OneViewController = (self.childViewControllers.first!as? OneViewController)!
        vc.view.frame = self.bacScrollView.bounds
        self.bacScrollView.addSubview(vc.view)
        
    }

    // MARK 添加控制器
    func addController() {
    
        let vc:OneViewController = OneViewController()
        weak var weakSelf = self
        vc.firstBlock = {(isScroll:Bool)->Void in
            self.isScroll = isScroll
            weakSelf?.isTouchToButton()
        }
        vc.view.backgroundColor = UIColor.whiteColor()
        firstVC = vc
        firstVC!.addObserver(self, forKeyPath: "offerY", options: NSKeyValueObservingOptions.New, context: nil)
        self.addChildViewController(vc)
        
        let vc2:TwoViewController = TwoViewController()
        vc2.secondBlock = {(isScroll:Bool)->Void in
            self.isScroll = isScroll
            weakSelf?.isTouchToButton()
        }
        vc2.view.backgroundColor = UIColor.whiteColor()
        secondVC = vc2
        secondVC!.addObserver(self, forKeyPath: "offerY", options: NSKeyValueObservingOptions.New, context: nil)
        self.addChildViewController(vc2)
        
        let vc3:ThreeViewController = ThreeViewController()
        vc3.threeBlock = {(isScroll:Bool)->Void in
            self.isScroll = isScroll
            weakSelf?.isTouchToButton()
        }
        vc3.view.backgroundColor = UIColor.whiteColor()
        threeVC = vc3
        threeVC!.addObserver(self, forKeyPath: "offerY", options: NSKeyValueObservingOptions.New, context: nil)
        self.addChildViewController(vc3)

    }
    
    // MARK 判断button是否可点击
    func isTouchToButton() {
        if self.isScroll == true {
            self.toorView.userInteractionEnabled = true
            self.toorViewH.userInteractionEnabled = true
        }else {
            self.toorView.userInteractionEnabled = false
            self.toorViewH.userInteractionEnabled = false
        }
    }
    
    // MARK kvo接收
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        let offsetY = change?["new"] as! CGFloat
        let s = offsetY - oldF
        oldF = offsetY
        self.toorView.frame.origin.y -= s
        if offsetY >= 136 {
            self.toorViewH.hidden = false
        }else {
            self.toorViewH.hidden = true
        }
        
        if offsetY > 0  {
            self.navView!.alpha = (offsetY - 10)/100
        }else if offsetY == 0 {
          UIView.animateWithDuration(0.23, animations: { ()->Void in
            self.navView!.alpha = 0.0
          })
        }
    }
    
    // 添加button
    func addButton() {
        for var i = 0; i < arrs.count; ++i{
            let W:CGFloat = orginW
            let H:CGFloat = 40
            let Y:CGFloat = 0
            let X:CGFloat = CGFloat(i) * (W + orginW) + W
            
            let button:UIButton = UIButton()
            button.frame = CGRect(x: X, y: Y, width: W, height: H)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.setTitle(arrs[i], forState: .Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(15.0)
            button.tag = i
            button.addTarget(self, action:"buttonAction:", forControlEvents: .TouchUpInside)
            self.toorView.addSubview(button)
            
            let buttonH:UIButton = UIButton()
            buttonH.frame = CGRect(x: X, y: Y, width: W, height: H)
            buttonH.setTitleColor(UIColor.blackColor(), forState: .Normal)
            buttonH.setTitle(arrs[i], forState: .Normal)
            buttonH.titleLabel?.font = UIFont.systemFontOfSize(15.0)
            buttonH.tag = i
            buttonH.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
            self.toorViewH.addSubview(buttonH)

        }
    }
    
    // button点击事件
    func buttonAction(sender:UIButton) {
        UIView.animateWithDuration(0.3) {() -> Void in
            self.scrollLineViewH.frame.origin.x = CGFloat(sender.tag) * (self.orginW + self.orginW) + self.orginW
            self.scrollLineView.frame.origin.x = CGFloat(sender.tag) * (self.orginW + self.orginW) + self.orginW
        }
        
        let selectedVC:UIViewController = self.childViewControllers[sender.tag]
        if (selectedVC.view.superview == nil) {
            selectedVC.view.frame = self.bacScrollView.bounds
            self.bacScrollView.addSubview(selectedVC.view)
        }
        self.bacScrollView.bringSubviewToFront(selectedVC.view)
    }
    
    // 添加控件
    func navTitleView() {
        bacScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: KWidth, height: KHeight))
        bacScrollView.delegate = self
        bacScrollView.showsVerticalScrollIndicator = false
        bacScrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(bacScrollView)
        
        navView = UIToolbar(frame: CGRect(x: 0, y: 0, width: KWidth, height: 64))
        navView!.backgroundColor = UIColor.whiteColor()
        navView!.layer.shadowColor = UIColor.grayColor().CGColor
        navView!.layer.shadowOpacity = 0.5
        navView!.layer.shadowOffset = CGSize(width: 0, height: 0.2)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 30, width: KWidth, height: 20))
        titleLabel.textColor = UIColor.orangeColor()
        titleLabel.text = "个人主页"
        titleLabel.font = UIFont.boldSystemFontOfSize(17.0)
        titleLabel.textAlignment = .Center
        navView!.addSubview(titleLabel)
        navView!.alpha = 0.0
        self.view.addSubview(navView!)
        
        toorViewH = UIToolbar(frame: CGRect(x: 0, y: 64, width: KWidth, height: 40))
        toorViewH.hidden = true
        self.view.insertSubview(toorViewH, aboveSubview: self.bacScrollView)
        scrollLineViewH = UIView(frame: CGRect(x: orginW, y: 37, width: orginW, height: 3))
        scrollLineViewH.backgroundColor = UIColor.greenColor()
        toorViewH.addSubview(scrollLineViewH)
        
        toorView = UIView(frame: CGRect(x: 0, y: 200, width: KWidth, height: 40))
        toorView.backgroundColor = UIColor(colorLiteralRed: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        toorView.layer.shadowColor = UIColor.grayColor().CGColor
        self.view.insertSubview(toorView, aboveSubview: self.bacScrollView)
        scrollLineView = UIView(frame: CGRect(x: orginW, y: 37, width: orginW, height: 3))
        scrollLineView.backgroundColor = UIColor.greenColor()
        toorView.addSubview(scrollLineView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

