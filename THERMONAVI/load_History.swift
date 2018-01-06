//
//  saveHistory.swift
//  THERMONAVI
//
//  Created by 土居将史 on 2017/12/01.
//  Copyright © 2017年 土居将史. All rights reserved.
// 履歴専用のメソッド

import Foundation
import UIKit

class history_load{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var flag = 0;
    var name:[String] = []
    var lat:[Double] = []
    var lon:[Double] = []
    
    func countload () -> (Int){
        if let namedata = appDelegate.savedata.object(forKey: "NAME"){
            return (namedata as AnyObject).count
        }
        return 0
}
    
    func loadtitle() -> Array<String>{
        if let namedata = appDelegate.savedata.object(forKey: "NAME"){
            return namedata as! Array<String>
        }
        return name
    }
}

