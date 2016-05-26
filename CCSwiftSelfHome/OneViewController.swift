//
//  OneViewController.swift
//  CCSwiftSelfHome
//
//  Created by admin on 16/5/24.
//  Copyright © 2016年 CuiXinKuan. All rights reserved.
//

import UIKit

typealias InforBlock = (inforBlock:Bool)->Void
class OneViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    let KWidth = UIScreen.mainScreen().bounds.size.width
    let KHeight = UIScreen.mainScreen().bounds.size.height
    var tbView:UITableView!
    dynamic var offerY:CGFloat = 0.0
    var headView:UIView!
    var firstBlock:InforBlock?
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createTableView()
    }

    // MARK TableView
    func createTableView() {
        tbView = UITableView(frame: CGRect(x: 0,y: 0,width: KWidth,height: KHeight),style:UITableViewStyle.Grouped)
        tbView.dataSource = self
        tbView.delegate = self
        self.view.addSubview(tbView!)
        
//        headView = NSBundle.mainBundle().loadNibNamed("HomePageMoreView", owner: self, options: nil).last as! HomePageMoreView
//        headView.frame = CGRect(x: 0,y: 0,width: KWidth,height: 200)
        headView = UIView(frame: CGRect(x: 0, y: 0, width: KWidth, height: 200))
        headView.backgroundColor = UIColor.purpleColor()
        self.tbView!.tableHeaderView = headView
        
        self.tbView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notiAction", name: "TwoSwift", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notiAction", name: "ThreeSwift", object: nil)
        
    }
    
    // MARK 接受通知
    func notiAction(notification:NSNotification) {
        var dic = notification.userInfo
        let y:CGFloat = (dic!["inforY"] as? CGFloat)!
        if y >= 136 {
            if tbView.contentOffset.y < 136 {
                tbView.contentOffset.y = 136
            }
        }else {
            tbView.contentOffset.y = y
        }
        
    }
    
    // MARK UITableViewDataSource,Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 40
        }else {
            return 50
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identity:String = "cell"
        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(identity, forIndexPath: indexPath)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: identity)
        }
        cell.textLabel?.text = "AngelaBaby  -- >\(indexPath.row)"
        if (indexPath.row % 3) == 0 {
            cell.backgroundColor = UIColor.orangeColor()
        }else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK scrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.offerY = scrollView.contentOffset.y
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (firstBlock != nil) {
            firstBlock!(inforBlock:true)
        }
        
        let offer:CGFloat = scrollView.contentOffset.y
        tbView.contentOffset.y = offer
        var dic:Dictionary<String,AnyObject> = Dictionary()
        dic["inforY"] = offer
        NSNotificationCenter.defaultCenter().postNotificationName("inforSwift", object: nil, userInfo: dic);
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if firstBlock != nil {
            firstBlock!(inforBlock:false)
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
