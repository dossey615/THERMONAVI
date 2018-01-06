//
//  BLE_controlViewController.swift
//  THERMONAVI
//
//  Created by 土居将史 on 2017/11/24.
//  Copyright © 2017年 土居将史. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLE_controlViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
        
        var centralManager: CBCentralManager!
        var peripheral: CBPeripheral!
        var characteristic: CBCharacteristic!
        var centralManagerReady: Bool = false
        var peripheralReady: Bool = false
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // MARK: - IBOutlet
        
        @IBOutlet weak var SSIDUILabel: UILabel!
        
        // MARK: - IBAction
    
    @IBAction func connectBtnTapped(_ sender: Any) {
        if !self.centralManagerReady {
            let alert: UIAlertController = UIAlertController(title: "THERMONAVIが\n見つかりません", message: "端末のBluetoothをON,またはTHERMONAVI本体をセットしてください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)

            return
        }
        self.scanBLESerial3()
    }
    
        // MARK: - CBCentralManager Delegate
        
        // CBCentralManagerの状態が変化するたびに呼ばれる
        func centralManagerDidUpdateState(_ central: CBCentralManager) {
            switch central.state {
            case .poweredOn:
                self.centralManagerReady = true
            default:
                break
            }
        }
    
        // Scanをして、該当のBLE(ペリフェラル)が見つかると呼ばれる
        // 第2引数に該当のBLE（ペリフェラル）が渡されてくる
        func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
            print("発見したBLE: \(peripheral)")
            self.stopScan()
            self.connectPeripheral(peripheral: peripheral)
        }
        
        // BLE（ペリフェラル）に接続が成功すると呼ばれる
        // 第2引数に接続したBLE（ペリフェラル）が渡されてくる
        func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
            print("接続したBLE: \(peripheral)")
            self.SSIDUILabel.text = peripheral.name
            self.scanService()
        }
        
        // MARK: - CBPeripheralDelegate Delegate
        
        // サービスを発見すると呼ばれる
        func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            let service: CBService = peripheral.services![0]
            self.scanCharacteristics(service)
        }
        
        // キャラスタリスティックを発見すると呼ばれる
        func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
            let characteristic: CBCharacteristic = service.characteristics![0]
            self.characteristic = characteristic
            appDelegate.ch = characteristic
            
            peripheralReady = true
            appDelegate.periReady = true
        }
        
        // MARK: - Method
        
        func scanBLESerial3() {
            let BLESerial3UUID: [CBUUID] = [CBUUID.init(string: "FEED0001-C497-4476-A7ED-727DE7648AB1")]
            self.centralManager?.scanForPeripherals(withServices: BLESerial3UUID, options: nil)
            appDelegate.cm?.scanForPeripherals(withServices: BLESerial3UUID, options: nil)
        }
        
        func stopScan() {
            self.centralManager.stopScan()
            appDelegate.cm.stopScan()
        }
        
        func connectPeripheral(peripheral: CBPeripheral) {
            self.peripheral = peripheral
            appDelegate.peri = peripheral
            self.centralManager.connect(self.peripheral, options: nil)
            appDelegate.cm.connect(appDelegate.peri, options: nil)
        }
        
        func scanService() {
            self.peripheral.delegate = self
            appDelegate.peri.delegate = self
            let TXCBUUID: [CBUUID] = [CBUUID.init(string: "FEED0001-C497-4476-A7ED-727DE7648AB1")]
            self.peripheral.discoverServices(TXCBUUID)
            appDelegate.peri.discoverServices(TXCBUUID)
        }
        
        func scanCharacteristics(_ service: CBService) {
            let characteristics: [CBUUID] = [CBUUID.init(string: "FEEDAA02-C497-4476-A7ED-727DE7648AB1")]
            self.peripheral.discoverCharacteristics(characteristics, for: service)
            appDelegate.peri.discoverCharacteristics(characteristics, for: service)
        }
        
        // MARK: - LifeCycle
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // centralManagerを初期化する
            self.centralManager = CBCentralManager(delegate: self, queue: nil)
            appDelegate.cm = CBCentralManager(delegate: self, queue: nil)
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
}
}

extension UIView {
    
    // 枠線の色
    @IBInspectable var borderColor: UIColor? {
        get {
            return layer.borderColor.map { UIColor(cgColor: $0) }
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    // 枠線のWidth
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    // 角丸設定
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
