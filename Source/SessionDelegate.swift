//
//  SessionDelegate.swift
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
/// Custom session delegate class for URLSession's callbacks and operations.
public final class SessionDelegate: NSObject {
    /// Clousure for `urlSession(_:didBecomeInvalidWithError:)` function in protocol `URLSessionDelegate`.
    public var sessionDidBecomeInvalid: ((URLSession, Error?) -> Void)?
    /// Clousure for `urlSession(_:didReceive:completionHandler:)` function in protocol `URLSessionDelegate`.
    public var sessionDidReceiveChallenge: ((URLSession, URLAuthenticationChallenge, (@escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)) -> Void)?
    
    /// Clousure for `urlSession(_:task:willPerformHTTPRedirection:newRequest:completionHandler:)` function in protocol `URLSessionTaskDelegate`.
    public var taskOfSessionWillPerformHTTPRedirection: ((URLSessionTask, URLSession, HTTPURLResponse, URLRequest, @escaping (URLRequest?) -> Void) -> Void)?
    /// Clousure for `urlSession(_:task:didReceive:completionHandler:)` function in protocol `URLSessionDelegate`.
    public var taskOfSessionDidReceiveChallenge: ((URLSessionTask, URLSession, URLAuthenticationChallenge, @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?
}

// MARK: URLSessionDelegate

extension SessionDelegate: URLSessionDelegate {
    /// Tells the delegate that the session has been invalidated.
    ///
    /// - parameter session: The session object that was invalidated.
    /// - parameter error:   The error that caused invalidation, or nil if the invalidation was explicit.
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        sessionDidBecomeInvalid?(session, error)
    }
    /// Requests credentials from the delegate in response to a session-level authentication request from the
    /// remote server.
    ///
    /// - parameter session:           The session containing the task that requested authentication.
    /// - parameter challenge:         An object that contains the request for authentication.
    /// - parameter completionHandler: A handler that your delegate method must call providing the disposition
    ///                                and credential.
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        sessionDidReceiveChallenge?(session, challenge, completionHandler)
    }
}

// MARK: URLSessionTaskDelegate

extension SessionDelegate: URLSessionTaskDelegate {
    /// Tells the delegate that the remote server requested an HTTP redirect.
    ///
    /// - parameter session:           The session containing the task whose request resulted in a redirect.
    /// - parameter task:              The task whose request resulted in a redirect.
    /// - parameter response:          An object containing the server’s response to the original request.
    /// - parameter request:           A URL request object filled out with the new location.
    /// - parameter completionHandler: A closure that your handler should call with either the value of the request
    ///                                parameter, a modified URL request object, or NULL to refuse the redirect and
    ///                                return the body of the redirect response.
    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        taskOfSessionWillPerformHTTPRedirection?(task, session, response, request, completionHandler)
    }
    /// Requests credentials from the delegate in response to an authentication request from the remote server.
    ///
    /// - parameter session:           The session containing the task whose request requires authentication.
    /// - parameter task:              The task whose request requires authentication.
    /// - parameter challenge:         An object that contains the request for authentication.
    /// - parameter completionHandler: A handler that your delegate method must call providing the disposition
    ///                                and credential.
    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        taskOfSessionDidReceiveChallenge?(task, session, challenge, completionHandler)
    }
}
