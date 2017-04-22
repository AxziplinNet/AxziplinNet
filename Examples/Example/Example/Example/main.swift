//
//  main.swift
//  Example
//
//  Created by devedbox on 2017/4/22.
//  Copyright © 2017年 jiangyou. All rights reserved.
//

import Cocoa
import AxziplinNet

let url = URL(string: "https://www.baidu.com")!
let request = try! URLEncoding.default.encode(URLRequest(url: url), with: ["aaa":"aaa", "bb": "bb", "c": true])

print(request.url!)

print("Hello, World!")


