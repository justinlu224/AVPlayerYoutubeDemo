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
    @IBOutlet weak var categoryView: CategoryView!
    @IBOutlet weak var categoryLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let categoryList = [news,society,popular,entertainment,global,life,focus,health,sport]
        calist = [news,society,popular,entertainment,global,life,focus,health,sport]
        categoryView.add(target: self, categoryItems: calist!)
    }
    @objc func buttonAction(_ sender: UIButton){
        categoryLabel.text = calist![sender.tag].name
//        categoryLabel.tintColor = UIColor.blue
        categoryLabel.textColor = UIColor.blue
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

