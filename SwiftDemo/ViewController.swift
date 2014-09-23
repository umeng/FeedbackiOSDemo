//
//  ViewController.swift
//  SwiftDemo
//
//  Created by amoblin on 14/9/23.
//  Copyright (c) 2014年 umeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var btn = UIButton(frame: CGRectMake(100, 200, 120, 20));
        btn.setTitleColor(UIColor(red: 0, green: 122.0/255, blue: 1.0, alpha: 1.0), forState: UIControlState.Normal);
        btn.setTitle("Feedback", forState:UIControlState.Normal);
        btn.addTarget(self, action: "webFeedback:", forControlEvents: UIControlEvents.TouchUpInside);
        self.view.addSubview(btn);
    }

    func webFeedback(sender: UIButton!) {
        UMFeedback.showFeedback(self, withAppkey: UMENG_APPKEY);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

