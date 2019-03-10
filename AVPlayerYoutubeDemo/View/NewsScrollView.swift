//
//  NewsScrollView.swift
//  AVPlayerYoutubeDemo
//
//  Created by Apple on 2019/3/10.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class NewsScrollView: UIScrollView,UIScrollViewDelegate {
    public var lastViewX: CGFloat = 0.0

    func creatMyScrollView(imageName:[String],height:CGFloat) {
        //動態布局
        for i in 0...(imageName.count - 1) {
            let imageView = UIImageView(frame: CGRect(x: lastViewX, y: 0, width: UIScreen.main.bounds.width, height: height))

            lastViewX = lastViewX + imageView.frame.size.width
            addSubview(imageView)
            //設置輪播圖圖片
            imageView.image = UIImage(named: imageName[i])
            print(imageName[i])
        //設置輪播圖容量
        contentSize = CGSize(width: CGFloat(imageName.count) * UIScreen.main.bounds.width , height: height)
        }
        //設置吸附屬性
        self.bounces = false
        //設置書頁效果
        self.isPagingEnabled = true
    }
}

