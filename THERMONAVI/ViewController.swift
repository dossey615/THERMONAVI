//
//  ViewController.swift
//  THERMONAVI
//
//  Created by 土居将史 on 2017/11/29.
//  Copyright © 2017年 土居将史. All rights reserved.
// mapの機能

import UIKit
import MapKit
import CoreBluetooth

class ViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate,UISearchBarDelegate{
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var SearchBar: UISearchBar!
    //ロングタップしたときに立てるピンを定義
    var pinByLongPress:MKPointAnnotation!
    //CLLocationManagerの入れ物
    var myLocationManager: CLLocationManager!
    let ble = BLE_controlViewController()
    let his = HistoryViewController()
    
    //送信座標
    var PointLatitude: Double!
    var PointLongitude: Double!
    
    //変数を複数画面で使用
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //履歴メソッドのインスタンス
    let savehis = history_save()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //デリゲート先を自分に設定する。
        self.MapView.delegate = self
        //インスタンス化
        myLocationManager = CLLocationManager()
        //位置情報使用許可のリクエストメソッド
        myLocationManager.requestWhenInUseAuthorization()
        //デリゲート先を自分に設定する。
        self.SearchBar.delegate = self
        //検索バーのキャンセルボタンテキスト
        SearchBar.setValue("キャンセル", forKey: "_cancelButtonText")
        //キャンセルボタンの色指定
        SearchBar.tintColor = UIColor.red
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error!")
    }
    
    
    @IBAction func LongPressMap(_ sender: UILongPressGestureRecognizer) {
        if(sender.state != UIGestureRecognizerState.began){
            return
        }
        //インスタンス化
        pinByLongPress = MKPointAnnotation()
        
        //ロングタップから位置情報を取得
        let location:CGPoint = sender.location(in: MapView)
        
        //取得した位置情報をCLLocationCoordinate2D（座標）に変換
        let longPressedCoordinate:CLLocationCoordinate2D = MapView.convert(location, toCoordinateFrom: MapView)
        
        pinByLongPress.title = "不明"
        pinByLongPress.subtitle = "不明"
        // geocoderを作成.
        let myGeocorder = CLGeocoder()
        // locationを作成.
        let myLocation = CLLocation(latitude: longPressedCoordinate.latitude, longitude: longPressedCoordinate.longitude)
        // 逆ジオコーディング開始.
        myGeocorder.reverseGeocodeLocation(myLocation,completionHandler: { (placemarks, error) -> Void in
            for placemark in placemarks! {
                if(placemark.postalCode != nil ){
                    self.pinByLongPress.subtitle = "〒\(String(describing: placemark.postalCode!))"
                    self.pinByLongPress.title = "\(String(describing: placemark.administrativeArea!))"+" "+"\(String(describing: placemark.locality!))"+" "+"\(String(describing: placemark.subLocality!))"
                }
            }
        })
        
        //ロングタップした位置の座標をピンに入力
        pinByLongPress.coordinate = longPressedCoordinate
        
        //ピンを追加する（立てる）
        self.MapView.addAnnotation(pinByLongPress)
        
    }
    //サーチバータッチ前
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool{
        searchBar.showsCancelButton = true
        return true
    }
    //キャンセルボタンが押された
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
        //キーボードを閉じる。
    }
    
    //検索ボタン押下時の呼び出しメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //キーボードを閉じる。
        SearchBar.resignFirstResponder()
        
        //検索条件を作成する。
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = SearchBar.text
        
        //検索範囲はマップビューと同じにする。
        request.region = MapView.region
        
        //ローカル検索を実行する。
        let localSearch:MKLocalSearch = MKLocalSearch(request: request)
        localSearch.start(completionHandler: {(result, error) in
            
            for placemark in (result?.mapItems)! {
                if(error == nil) {
                    
                    //検索された場所にピンを刺す。
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(placemark.placemark.coordinate.latitude, placemark.placemark.coordinate.longitude)
                    annotation.title = placemark.placemark.name
                    annotation.subtitle = placemark.placemark.title
                    self.MapView.addAnnotation(annotation)
                    //中心座標
                    let center = annotation.coordinate
                    
                    //表示範囲
                    let span = MKCoordinateSpanMake(0.1, 0.1)
                    
                    //中心座標と表示範囲をマップに登録する。
                    let region = MKCoordinateRegionMake(center, span)
                    self.MapView.setRegion(region, animated:true)
                } else {
                    //エラー
                    print("error")
                }
            }
        })
    }
    func mapView(_ MapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for view in views {
            view.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
        }
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (view.annotation?.title)! != "My Location"{
            self.PointLatitude = (view.annotation?.coordinate.latitude)!
            self.PointLongitude = (view.annotation?.coordinate.longitude)!
            print(self.PointLatitude)
            self.showAlert(post: (view.annotation!.subtitle)!!, name: (view.annotation!.title)!!, lat:self.PointLatitude, lon: self.PointLongitude)
        }else{
            let alert: UIAlertController = UIAlertController(title: "現在地はナビゲーションできません", message: "他の場所を選択してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlert(post:String, name:String, lat:Double, lon:Double) {
        // アラートを作成
        let alert = UIAlertController(
            title: "この目的地のナビゲーションを開始してもよろしいですか？",
            message: post+" "+name,
            preferredStyle: .actionSheet)
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "ナビゲーションを開始", style: .default, handler: { action in
            if self.appDelegate.periReady {
    
                //接続済の場合、緯度経度を送信
                var  point_1:Int = Int(lat)
            let data_1: NSData = NSData.init(bytes: &point_1, length: 1)
                self.appDelegate.peri.writeValue(data_1 as Data, for: self.appDelegate.ch, type: .withoutResponse)
                var point_2 :Int = Int(lon)
           let data_2: NSData = NSData.init(bytes: &point_2, length: 1)
                self.appDelegate.peri.writeValue(data_2 as Data, for: self.appDelegate.ch, type: .withoutResponse)
                self.savehis.saveh(name: name, lat: lat, lon: lon)
            }else{
                //未接続時メッセージ
                let alert: UIAlertController = UIAlertController(title: "THERMONAVIが\n設定されていません", message: "端末,アプリのBluetoothを\nセットしてください", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
            }
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }
    
}



