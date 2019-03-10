//
//  CategoryViewController.swift
//  AVPlayerYoutubeDemo
//
//  Created by Apple on 2019/3/10.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    let news = Category.init(id: 0, name: "即時")
    let society = Category.init(id: 1, name: "社會")
    let popular = Category.init(id: 2, name: "熱門")
    let entertainment = Category.init(id: 3, name: "娛樂")
    let global = Category.init(id: 4, name: "全球")
    let life = Category.init(id: 5, name: "生活")
    let focus = Category.init(id: 6, name: "Focus")
    let health = Category.init(id: 7, name: "健康")
    let sport = Category.init(id: 8, name: "運動")
    var calist:[Category]?
    let imageView = ["1", "2", "3"]
    var page = UIPageControl()
    @IBOutlet weak var categoryView: CategoryView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var newsView: NewsScrollView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        newsView.creatMyScrollView(imageName: imageView, height: newsView.bounds.height)
        calist = [news,society,popular,entertainment,global,life,focus,health,sport]
        categoryView.add(target: self, categoryItems: calist!)
        setPageControl()
    }
    
    func setPageControl(){
        page.frame = CGRect(x: view.frame.width/3, y: (newsView.frame.origin.y + newsView.bounds.height) - 25, width: 100, height: 30)
        //總共頁數
        page.numberOfPages = imageView.count
        //設定當前頁面顏色
        page.currentPageIndicatorTintColor = UIColor.red
        //非當前頁面顏色
        page.pageIndicatorTintColor = UIColor.white
        view.addSubview(page)
    }
    
    @objc func buttonAction(_ sender: UIButton){
        categoryLabel.text = calist![sender.tag].name
        categoryLabel.textColor = UIColor.blue
    }
}
extension CategoryViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("page = \(Int(newsView.contentOffset.x / view.frame.width))")
        page.currentPage = Int(newsView.contentOffset.x / view.frame.width)
    }
}

