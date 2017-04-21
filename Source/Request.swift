//
//  Request.swift
//  AxziplinNet
//
//  Created by devedbox on 2017/4/21.
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

/// Types adopting the `URLRequestConvertible` protocol can be used to construct URL requests.
public protocol URLRequestConvertible {
    /// Returns a URL request or throws if an `Error` was encountered.
    ///
    /// - throws: An `Error` if the underlying `URLRequest` is `nil`.
    ///
    /// - returns: A URL request.
    func asURLRequest() throws -> URLRequest
}

/// Types adopting the `URLConvertible` protocol can be used to construct URLs, which are then used to construct
/// URL requests.
public protocol URLConvertible {
    /// Returns a URL that conforms to RFC 2396 or throws an `Error`.
    ///
    /// - throws: An `Error` if the type cannot be converted to a `URL`.
    ///
    /// - returns: A URL or throws an `Error`.
    func asURL() throws -> URL
}

public protocol RequestResult {
    
}

public protocol RequestEncoding {
    func encode(_ request: URLRequestConvertible, with parameters: Request.RequestParameters) throws -> URLRequest?
}

public class Request {}

extension Request {
    public typealias RequestParameters = [String: Any]
}

extension URLRequestConvertible {
    var request: URLRequest? { return try? asURLRequest() }
}

extension URLRequest: URLRequestConvertible {
    public func asURLRequest() throws -> URLRequest { return self }
}

extension URLConvertible {
    public var url: URL? {
        return try? asURL()
    }
}

extension String: URLConvertible {
    public func asURL() throws -> URL {
        guard let url = URL(string: self) else { throw AxziplinError.InvalidURL(url: self) }
        return url
    }
}
