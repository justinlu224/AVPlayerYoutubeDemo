//
//  LikeYoutubeViewController.swift
//  AVPlayerYoutubeDemo
//
//  Created by Apple on 2019/3/7.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import AVFoundation

class LikeYoutubeViewController: UIViewController {
    @IBOutlet weak var viewRectView: UIView!
    @IBOutlet weak var infoContainerView: UIView!
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
    //目前位移量
    var currentOffSet:CGFloat = 0
    
    var tap:UITapGestureRecognizer!
    var player:AVPlayer = AVPlayer()
    var playerLayer:AVPlayerLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 在view上加入拖動手勢，上下拉動效果
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panHandler(_ :))))
        //加入點擊手勢
        tap = UITapGestureRecognizer(target: self, action: #selector(tap(_ :)))
        tap.isEnabled = false
        view.addGestureRecognizer(tap)
    
        let url = URL(string: "https://content.jwplatform.com/manifests/vM7nH0Kl.m3u8")
        let playerItem = AVPlayerItem(url: url!)
        //更換當前播放項目
        player.replaceCurrentItem(with: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        //如果影片沒有佔滿整個畫面，讓背景為黑色較佳
        playerLayer.backgroundColor = UIColor.black.cgColor
        //將layer加入
        self.view.layer.addSublayer(playerLayer)
        
        //監聽手機有沒有翻轉，即使已經設定只能直向使用
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange(_ :)), name:UIDevice.orientationDidChangeNotification, object: nil)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playerLayer.frame = viewRectView.frame
        player.play()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
    }
    
    @objc
    func deviceOrientationDidChange(_ notification:Notification){
        //轉向時畫面放大
        toMax()
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            //轉換角度，z軸為原地轉換角度
            playerLayer.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1)
            playerLayer.frame = UIScreen.main.bounds
            CATransaction.commit()
            break
        case .landscapeRight:
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            playerLayer.transform = CATransform3DMakeRotation(CGFloat.pi / -2, 0, 0, 1)
            playerLayer.frame = UIScreen.main.bounds
            CATransaction.commit()
            break
        default:
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            playerLayer.transform = CATransform3DMakeRotation(0, 0, 0, 1)
            playerLayer.frame = CGRect(origin: .zero, size: CGSize(width: origWidth, height: origWidth / 16*9))
            CATransaction.commit()
            break
        }
        
    }
    
    
    //點擊畫面放到最大
    @objc
    func tap(_ tap:UITapGestureRecognizer){
        toMax()
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
            
            infoContainerView.alpha = (newWidth - minWidth) / origWidth
           
            CATransaction.begin()
            //設置動畫效果是否顯示
            CATransaction.setDisableActions(true)
            //讓影片在拖動畫面時會跟著畫面一起縮放
            playerLayer.frame = CGRect(origin: .zero, size: CGSize(width: newWidth, height: newWidth / 16*9))
            CATransaction.commit()

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
        tap.isEnabled = true
        let x = origWidth - minWidth
        let y = origHeight - minHeight-49
        
        UIView.animate(withDuration: 1) {
            self.view.frame = CGRect(x: x, y: y, width: self.minWidth, height: self.minHeight)
            self.view.layoutIfNeeded()
        }
         playerLayer.frame = viewRectView.frame
        self.startOffSet = maxOffSet
    }
    func toMax(){
        tap.isEnabled = false
        UIView.animate(withDuration: 1) {
            self.view.frame = CGRect(origin: .zero, size: CGSize(width: self.origWidth, height: self.origHeight))
                        self.view.layoutIfNeeded()
        }
         playerLayer.frame = viewRectView.frame
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
