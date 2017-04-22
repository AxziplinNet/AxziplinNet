//
//  Session.swift
//  AxziplinNet
//
//  Created by devedbox on 2017/4/19.
//  Copyright © 2017年 devedbox. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
/// Session manager of url requests.
@available(OSX 10.9, *)
public final class Session {
    // MARK: -
    // MARK: Properties.
    public class var `default`: Session { return Session() }
    
    /// Get the managed session object of `Session` class.
    public var session: URLSession { return _session }
    // MARK: Private Properties.
    /// Underlying sessiong instance object of URLSession.
    private var _session: URLSession
    
    // MARK: - Life Cycle.
    /// Creates a `Session` object using a configuration, delegate and delege queue.
    ///
    /// - Parameters:
    ///   - configuration: Object of `URLSessionConfiguration` to create underlying `URLSession` object.
    ///   - delegate     : Delegate object of `SessionDelegate` to create underlying `URLSession` object.
    ///   - delegateQueue: `OperationQueue` object used by `URLSession` delegate.
    public init(
        configuration: URLSessionConfiguration = .default,
        delegate: SessionDelegate = SessionDelegate(), delegateQueue:
        OperationQueue? = nil)
    {
        _session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: delegateQueue)
    }
    /// Releases all resources.
    deinit {
        _session.invalidateAndCancel()
    }
    
    // MARK: Data Request.
    
    public func request(
        _ url: URLConvertible,
        using method: Request.HTTPMethod = .get,
        with parameters: Request.RequestParameters? = nil,
        encoding: Request.URLEncoding = .default,
        headers: Request.RequestHeaders? = nil) -> RequestResult?
    {
        do {
            var request = try URLRequest(url: url.asURL(), cachePolicy: .useProtocolCachePolicy, timeoutInterval: _session.configuration.timeoutIntervalForRequest)
            request.httpMethod = method.rawValue
            
            if let headers = headers {
                for (field, value) in headers {
                    request.setValue(value, forHTTPHeaderField: field)
                }
            }
            
            let encodedRequest = try encoding.encode(request, with: parameters)
            
            return self.request(encodedRequest)
        } catch let error {
            
        }
        return nil
    }
    
    public func request(_ request: URLRequestConvertible) -> RequestResult? {
        return nil
    }
}
