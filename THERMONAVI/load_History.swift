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
    
    func clearData(){
        if var namedata = appDelegate.savedata.object(forKey: "NAME") as? [String] {
            var latdata = appDelegate.savedata.object(forKey: "LAT") as! [Double]
            var londata = appDelegate.savedata.object(forKey: "LON") as! [Double]
            namedata.removeAll()
            latdata.removeAll()
            londata.removeAll()
            appDelegate.savedata.set(namedata, forKey:"NAME")
            appDelegate.savedata.set(latdata, forKey:"LAT")
            appDelegate.savedata.set(londata, forKey:"LON")
    }
    }
    
}

