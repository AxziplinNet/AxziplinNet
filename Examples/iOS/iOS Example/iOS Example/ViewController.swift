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
        let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
        let task = session.dataTask(with: URLRequest(url: URL(string:"http://sh.dhjie.cn/exchangeStreet/user/client/general/flash/fetch")!))
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

