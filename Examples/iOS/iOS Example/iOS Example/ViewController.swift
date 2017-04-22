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
        var data = Data()
        
        delegate.dataTaskOfSessionDidReceiveData = { dataTask, session, responseData in
            data.append(responseData)
            print("\(data)")
        }
        delegate.taskOfSessionDidComplete = { task, session, error in
            // let string = String(data: data, encoding: .utf8)
            // print(string ?? "")
            do {
                try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            } catch let err {
                print("error: \(err)")
            }
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        var request = URLRequest(url: URL(string:"https://itunes.apple.com/cn/app/xun-qin-ji/id1166476826?mt=8")!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        request.httpMethod = Request.HTTPMethod.get.rawValue
        let session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
        // let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request)
        // let task = session.dataTask(with: request) { (data, response, error) in
        //     print("\(data)")
        // }
        
        task.resume()
        
        let url = URL(string: "https://www.baidu.com")!
        let urlRequest = try! URLEncoding.default.encode(URLRequest(url: url), with: ["aaa":"aaa", "bb": "bb", "c": true])
        
        print(urlRequest.url!)
        print(String(data: urlRequest.httpBody ?? Data(), encoding: .utf8) ?? "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

