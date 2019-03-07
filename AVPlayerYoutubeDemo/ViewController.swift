//
//  ViewController.swift
//  AVPlayerYoutubeDemo
//
//  Created by Apple on 2019/3/7.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let vc = LikeYoutubeViewController()
        self.addChild(vc)
        self.view.addSubview(vc.view)
        
        vc.didMove(toParent: self)
        vc.view.frame = UIScreen.main.bounds
    }

}

