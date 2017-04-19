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
        let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
        let task = session.dataTask(with: URLRequest(url: URL(string:"https://www.baidu.com")!))
        task.resume()
        delegate.dataTaskOfSessionDidReceiveData = { dataTask, session, data in
            print("\(data)")
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

