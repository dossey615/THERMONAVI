//
//  saveHistory.swift
//  THERMONAVI
//
//  Created by 土居将史 on 2017/12/01.
//  Copyright © 2017年 土居将史. All rights reserved.
// 履歴専用のメソッド

import Foundation
import UIKit

class history_save{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var flag = 0;
    //保存用の配列
    var name:[String] = []
    var lat:[Double] = []
    var lon:[Double] = []
    
    func saveh (name: String, lat: Double, lon: Double){
        if var namedata = appDelegate.savedata.object(forKey: "NAME") as? [String] {
            var latdata = appDelegate.savedata.object(forKey: "LAT") as! [Double]
            var londata = appDelegate.savedata.object(forKey: "LON") as! [Double]
            namedata.insert(name,at:0)
            latdata.insert(lat,at:0)
            londata.insert(lon,at:0)
            appDelegate.savedata.set(namedata, forKey:"NAME")
            appDelegate.savedata.set(latdata, forKey:"LAT")
            appDelegate.savedata.set(londata, forKey:"LON")
        }else{
            self.name.insert(name,at:0)
            self.lat.insert(lat,at:0)
            self.lon.insert(lon,at:0)
            appDelegate.savedata.set(self.name, forKey:"NAME")
            appDelegate.savedata.set(self.lat, forKey:"LAT")
            appDelegate.savedata.set(self.lon, forKey:"LON")
        }
        appDelegate.savedata.synchronize()
    }

}
