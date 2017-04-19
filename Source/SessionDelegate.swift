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
    /// Closure for `urlSession(_:didBecomeInvalidWithError:)` function in protocol `URLSessionDelegate`.
    public var sessionDidBecomeInvalid: ((URLSession, Error?) -> Void)?
    /// Closure for `urlSession(_:didReceive:completionHandler:)` function in protocol `URLSessionDelegate`.
    public var sessionDidReceiveChallenge: ((URLSession, URLAuthenticationChallenge, (@escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)) -> Void)?
    
    /// Closure for `urlSession(_:task:willPerformHTTPRedirection:newRequest:completionHandler:)` function in protocol `URLSessionTaskDelegate`.
    public var taskOfSessionWillPerformHTTPRedirection: ((URLSessionTask, URLSession, HTTPURLResponse, URLRequest, @escaping (URLRequest?) -> Void) -> Void)?
    /// Closure for `urlSession(_:task:didReceive:completionHandler:)` function in protocol `URLSessionTaskDelegate`.
    public var taskOfSessionDidReceiveChallenge: ((URLSessionTask, URLSession, URLAuthenticationChallenge, @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?
    /// Closure for `urlSession(_:task:needNewBodyStream:)` function in protocol `URLSessionTaskDelegate`.
    public var taskOfSessionNeedNewBodyStream: ((URLSessionTask, URLSession, @escaping (InputStream?) -> Void) -> Void)?
    /// Closure for `urlSession(_:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:)` function in protocol `URLSessionTaskDelegate`.
    public var taskOfSessionDidSendData: ((URLSessionTask, URLSession, Int64, Int64, Int64) -> Void)?
    /// Closure for `urlSession(_:task:didFinishCollecting:)` function in protocol `URLSessionTaskDelegate`.
    public var taskOfSessionDidFinishCollecting: ((URLSessionTask, URLSession, URLSessionTaskMetrics) -> Void)?
    /// Closure for `urlSession(_:task:didComplete:)` function in protocol `URLSessionTaskDelegate`.
    public var taskOfSessionDidComplete: ((URLSessionTask, URLSession, Error?) -> Void)?
    
    /// Closure for `urlSession(_:dataTask:didReceive:completionHandler:)` function in protocol `URLSessionDataDelegate`.
    public var dataTaskOfSessionDidReceiveResponse: ((URLSessionDataTask, URLSession, URLResponse, @escaping (URLSession.ResponseDisposition) -> Void) -> Void)?
    /// Closure for `urlSession(_:dataTask:didBecome:)` function in protocol `URLSessionDataDelegate`.
    public var dataTaskOfSessionDidBecomeDownloadTask: ((URLSessionDataTask, URLSession, URLSessionDownloadTask) -> Void)?
    /// Closure for `urlSession(_:dataTask:didBecome:)` function in protocol `URLSessionDataDelegate`.
    public var dataTaskOfSessionDidBecomeStreamTask: ((URLSessionDataTask, URLSession, URLSessionStreamTask) -> Void)?
    /// Closure for `urlSession(_:dataTask:didReceive:)` function in protocol `URLSessionDataDelegate`.
    public var dataTaskOfSessionDidReceiveData: ((URLSessionDataTask, URLSession, Data) -> Void)?
    /// Closure for `urlSession(_:dataTask:willCacheResponse:)` function in protocol `URLSessionDataDelegate`.
    public var dataTaskOfSessionWillCacheResponse: ((URLSessionDataTask, URLSession, CachedURLResponse, @escaping (CachedURLResponse?) -> Void) -> Void)?

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

@available(OSX 10.9, *)
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
    /// Tells the delegate when a task requires a new request body stream to send to the remote server.
    ///
    /// - parameter session:           The session containing the task that needs a new body stream.
    /// - parameter task:              The task that needs a new body stream.
    /// - parameter completionHandler: A completion handler that your delegate method should call with the new body stream.
    public func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {
        taskOfSessionNeedNewBodyStream?(task, session, completionHandler)
    }
    /// Periodically informs the delegate of the progress of sending body content to the server.
    ///
    /// - parameter session:                  The session containing the data task.
    /// - parameter task:                     The data task.
    /// - parameter bytesSent:                The number of bytes sent since the last time this delegate method was called.
    /// - parameter totalBytesSent:           The total number of bytes sent so far.
    /// - parameter totalBytesExpectedToSend: The expected length of the body data.
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        taskOfSessionDidSendData?(task, session, bytesSent, totalBytesSent, totalBytesExpectedToSend)
    }
    /// Tells the delegate that the session finished collecting metrics for the task.
    ///
    /// - parameter session: The session collecting the metrics.
    /// - parameter task:    The task whose metrics have been collected.
    /// - parameter metrics: The collected metrics.
    @available(OSX 10.12, *)
    public func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        taskOfSessionDidFinishCollecting?(task, session, metrics)
    }
    /// Tells the delegate that the task finished transferring data.
    ///
    /// - parameter session: The session containing the task whose request finished transferring data.
    /// - parameter task:    The task whose request finished transferring data.
    /// - parameter error:   If an error occurred, an error object indicating how the transfer failed, otherwise nil.
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        taskOfSessionDidComplete?(task, session, error)
    }
}

extension SessionDelegate: URLSessionDataDelegate {
    /// Tells the delegate that the data task received the initial reply (headers) from the server.
    ///
    /// - parameter session:           The session containing the data task that received an initial reply.
    /// - parameter dataTask:          The data task that received an initial reply.
    /// - parameter response:          A URL response object populated with headers.
    /// - parameter completionHandler: A completion handler that your code calls to continue the transfer, passing a
    ///                                constant to indicate whether the transfer should continue as a data task or
    ///                                should become a download task.
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        dataTaskOfSessionDidReceiveResponse?(dataTask, session, response, completionHandler)
    }
    /// Tells the delegate that the data task was changed to a download task.
    ///
    /// - parameter session:      The session containing the task that was replaced by a download task.
    /// - parameter dataTask:     The data task that was replaced by a download task.
    /// - parameter downloadTask: The new download task that replaced the data task.
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        dataTaskOfSessionDidBecomeDownloadTask?(dataTask, session, downloadTask)
    }
    /// Tells the delegate that the data task was changed to a stream task.
    ///
    /// - parameter session:      The session containing the task that was replaced by a stream task.
    /// - parameter dataTask:     The data task that was replaced by a stream task.
    /// - parameter streamTask:   The new stream task that replaced the data task.
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
        dataTaskOfSessionDidBecomeStreamTask?(dataTask, session, streamTask)
    }
    /// Tells the delegate that the data task has received some of the expected data.
    ///
    /// - parameter session:  The session containing the data task that provided data.
    /// - parameter dataTask: The data task that provided data.
    /// - parameter data:     A data object containing the transferred data.
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        dataTaskOfSessionDidReceiveData?(dataTask, session, data)
    }
    /// Asks the delegate whether the data (or upload) task should store the response in the cache.
    ///
    /// - parameter session:           The session containing the data (or upload) task.
    /// - parameter dataTask:          The data (or upload) task.
    /// - parameter proposedResponse:  The default caching behavior. This behavior is determined based on the current
    ///                                caching policy and the values of certain received headers, such as the Pragma
    ///                                and Cache-Control headers.
    /// - parameter completionHandler: A block that your handler must call, providing either the original proposed
    ///                                response, a modified version of that response, or NULL to prevent caching the
    ///                                response. If your delegate implements this method, it must call this completion
    ///                                handler; otherwise, your app leaks memory.
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        dataTaskOfSessionWillCacheResponse?(dataTask, session, proposedResponse, completionHandler)
    }
}


