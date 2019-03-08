//
//  LikeYoutubeViewController.swift
//  AVPlayerYoutubeDemo
//
//  Created by Apple on 2019/3/7.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class LikeYoutubeViewController: UIViewController {
    //畫面拉下後的最小寬度
    var minWidth:CGFloat{
        return UIScreen.main.bounds.size.width/4
    }
    //畫面拉下後的最小高度
    var minHeight:CGFloat{
        return minWidth/16*9
    }
    //最大位移數
    var maxOffSet:CGFloat{
        return UIScreen.main.bounds.size.height - minHeight
    }
    //原始高度
    var origHeight:CGFloat{
        return UIScreen.main.bounds.size.height
    }
    //原始寬度
    var origWidth:CGFloat{
        return UIScreen.main.bounds.size.width
    }
    //起始位置
    var startPosition:CGPoint = .zero
    //起始位移量
    var startOffSet:CGFloat = 0
    
    var currentOffSet:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 在view上加入拖動手勢，上下拉動效果
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panHandler(_ :))))
    }
    //上下拉動效果
    @objc
    func panHandler(_ gesture:UIPanGestureRecognizer){
        //偵測手勢狀態
        switch gesture.state {
            
        case .began:
            //在拖動畫面時，以容器view的位置做基準，如果用自己在移動時位置及大小會一直改變無法做無基準。
            self.startPosition = gesture.translation(in: self.view.superview)
            break
        case .changed:
            //拖動時的位置
            let position = gesture.translation(in: self.view.superview)
            //位移量
            currentOffSet = position.y - startPosition.y
            let newY = startOffSet + currentOffSet
            var newHeight = origHeight - newY
            //避免拖動時返回數值大於原本的高和小於最小的高，用以下兩行做判斷取新的高度值
            //返回兩值中較小的那個
            newHeight = min(newHeight, origHeight)
            //返回兩值中較大的
            newHeight = max(newHeight, minHeight)
            
            //算出高度縮放比例
            let rate = newHeight / origHeight
            var newWidth = origWidth * rate
            
            newWidth = min(newWidth, origWidth)
            newWidth = max(newWidth, minWidth)
            
            let newX = origWidth - newWidth
            self.view.frame = CGRect(origin: CGPoint(x: newX, y: newY), size: CGSize(width: newWidth, height: newHeight))
            
            break
        case .ended:
            //如果移動後的位置大於原來高度的1/3,讓畫面縮到最小 反之最大
            if self.currentOffSet > origHeight/3{
                self.toMin()
            }else{
                self.toMax()
            }
            
            break
        default:
            break
        }
    }
    
    func toMin(){
        let x = origWidth - minWidth
        let y = origHeight - minHeight
        
        UIView.animate(withDuration: 1) {
            self.view.frame = CGRect(x: x, y: y, width: self.minWidth, height: self.minHeight)
            self.view.layoutIfNeeded()
        }
        self.startOffSet = maxOffSet
    }
    func toMax(){
        
        UIView.animate(withDuration: 1) {
            self.view.frame = CGRect(origin: .zero, size: CGSize(width: self.origWidth, height: self.origHeight))
                        self.view.layoutIfNeeded()
        }
        self.startOffSet = 0
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
