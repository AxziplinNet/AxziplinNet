//
//  ViewController.swift
//  iOS Example
//
//  Created by devedbox on 2017/4/19.
//  Copyright © 2017年 jiangyou. All rights reserved.
//

import UIKit
import AxziplinNet

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let delegate = SessionDelegate()
        delegate.dataTaskOfSessionDidReceiveData = { dataTask, session, data in
            print("\(data)")
        }
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        let request = URLRequest(url: URL(string:"https://itunes.apple.com/cn/app/xun-qin-ji/id1166476826?mt=8")!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        let session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
        // let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request)
        // let task = session.dataTask(with: request) { (data, response, error) in
        //     print("\(data)")
        // }
        
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

