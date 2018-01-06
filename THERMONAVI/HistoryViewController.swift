//
//  HistoryViewController.swift
//  THERMONAVI
//
//  Created by 土居将史 on 2017/12/01.
//  Copyright © 2017年 土居将史. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func clear(_ sender: Any) {
        let alert = UIAlertController(
            title: "履歴を削除してもよろしいですか？",
            message:"すべて消えます",
            preferredStyle: .actionSheet)
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "履歴を削除", style: .destructive, handler: { action in
            self.loadInfo.clearData()
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }
    //load用のインスタンス生成
    let loadInfo = history_load()
    
    var loadCount = 0
    var loadName:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.loadName = loadInfo.loadtitle()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = loadName[indexPath.row]
        return cell
    }

}
