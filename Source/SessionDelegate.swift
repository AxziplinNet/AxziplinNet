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

    /// Closure for `urlSession(_:downloadTask:didFinishDownloadingTo:)` function in protocol `URLSessionDownloadDelegate`.
    public var downloadTaskOfSessionDidFinishDownloading: ((URLSessionDownloadTask, URLSession, URL) -> Void)?
    /// Closure for `urlSession(_:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:)` function in protocol `URLSessionDownloadDelegate`.
    public var downloadTaskOfSessionDidWriteData: ((URLSessionDownloadTask, URLSession, Int64, Int64, Int64) -> Void)?
    /// Closure for `urlSession(_:downloadTask:didResumeAtOffset:expectedTotalBytes:)` function in protocol `URLSessionDownloadDelegate`.
    public var downloadTaskOfSessionDidResume: ((URLSessionDownloadTask, URLSession, Int64, Int64) -> Void)?
    
    /// Closure for `urlSession(_:readClosedFor:)` function in protocol `URLSessionStreamDelegate`.
    public var streamTaskOfSessionReadClosed: ((URLSessionStreamTask, URLSession) -> Void)?
    /// Closure for `urlSession(_:writeClosedFor:)` function in protocol `URLSessionStreamDelegate`.
    public var streamTaskOfSessionWriteClosed: ((URLSessionStreamTask, URLSession) -> Void)?
    /// Closure for `urlSession(_:betterRouteDiscoveredFor:)` function in protocol `URLSessionStreamDelegate`.
    public var streamTaskOfSessionBetterRouteDiscovered: ((URLSessionStreamTask, URLSession) -> Void)?
    // MARK: URLCredential
    ///
    public var credentialOfChallenge: ((URLSession, URLSessionTask?, URLAuthenticationChallenge) -> URLCredential?)?
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
        // Using did receive challenge closure.
        if let _challenge = sessionDidReceiveChallenge {
            _challenge(session, challenge, completionHandler)
            return
        }
        // Run default configuration of challenge:
        let previousFailureCount = challenge.previousFailureCount
        // Cancel challenge if failed many times.
        guard challenge.previousFailureCount == 0 else {
            challenge.sender?.cancel(challenge)
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        // Using the credential of custom closure results by user.
        if let _credentialGetter = credentialOfChallenge {
            if let _credential = _credentialGetter(session, nil, challenge) {
                completionHandler(.useCredential, _credential)
            }
            return
        }
        
        // Performing default handling without credential.
        completionHandler(.performDefaultHandling, nil)
        
        let protectionSpace = challenge.protectionSpace
        let proposedCredential = challenge.proposedCredential
        let failureResponse = challenge.failureResponse
        let error = challenge.error
        let sender = challenge.sender
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

// MARK: URLSessionDataDelegate

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

// MARK: URLSessionDownloadDelegate

extension SessionDelegate: URLSessionDownloadDelegate {
    /// Tells the delegate that a download task has finished downloading.
    ///
    /// - parameter session:      The session containing the download task that finished.
    /// - parameter downloadTask: The download task that finished.
    /// - parameter location:     A file URL for the temporary file. Because the file is temporary, you must either
    ///                           open the file for reading or move it to a permanent location in your app’s sandbox
    ///                           container directory before returning from this delegate method.
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        downloadTaskOfSessionDidFinishDownloading?(downloadTask, session, location)
    }
    /// Periodically informs the delegate about the download’s progress.
    ///
    /// - parameter session:                   The session containing the download task.
    /// - parameter downloadTask:              The download task.
    /// - parameter bytesWritten:              The number of bytes transferred since the last time this delegate
    ///                                        method was called.
    /// - parameter totalBytesWritten:         The total number of bytes transferred so far.
    /// - parameter totalBytesExpectedToWrite: The expected length of the file, as provided by the Content-Length
    ///                                        header. If this header was not provided, the value is
    ///                                        `NSURLSessionTransferSizeUnknown`.
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        downloadTaskOfSessionDidWriteData?(downloadTask, session, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
    }
    /// Tells the delegate that the download task has resumed downloading.
    ///
    /// - parameter session:            The session containing the download task that finished.
    /// - parameter downloadTask:       The download task that resumed. See explanation in the discussion.
    /// - parameter fileOffset:         If the file's cache policy or last modified date prevents reuse of the
    ///                                 existing content, then this value is zero. Otherwise, this value is an
    ///                                 integer representing the number of bytes on disk that do not need to be
    ///                                 retrieved again.
    /// - parameter expectedTotalBytes: The expected length of the file, as provided by the Content-Length header.
    ///                                 If this header was not provided, the value is NSURLSessionTransferSizeUnknown.
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        downloadTaskOfSessionDidResume?(downloadTask, session, fileOffset, expectedTotalBytes)
    }
}

// MARK: URLSessionStreamDelegate

extension SessionDelegate: URLSessionStreamDelegate {
    /// Tells the delegate that the read side of the underlying socket has been closed.
    /// This method may be called even if no reads are currently in progress. This method does not indicate that the stream reached end-of-file (EOF), such that no more data can be read.
    /// - Parameters:
    ///   - session:    The session containing the stream task that closed reads.
    ///   - streamTask: The stream task that closed reads.
    public func urlSession(_ session: URLSession, readClosedFor streamTask: URLSessionStreamTask) {
        streamTaskOfSessionReadClosed?(streamTask, session)
    }
    /// Tells the delegate that the write side of the underlying socket has been closed.
    /// This method may be called even if no writes are currently in progress.
    /// - Parameters:
    ///   - session:    The session containing the stream task that closed writes.
    ///   - streamTask: The stream task that closed writes.
    public func urlSession(_ session: URLSession, writeClosedFor streamTask: URLSessionStreamTask) {
        streamTaskOfSessionWriteClosed?(streamTask, session)
    }
    /// Tells the delegate that a better route to the host has been detected for the stream.
    /// This method is called when the URL loading system determines that a better route to the endpoint host is available. For example, this method may be called when a Wi-Fi interface becomes available.
    /// You should consider completing pending work and creating a new stream task in order to take advantage of better routes when they become available.
    /// - Parameters:
    ///   - session:    The session of the stream task that discovered a better route.
    ///   - streamTask: The stream task that discovered a better route.
    public func urlSession(_ session: URLSession, betterRouteDiscoveredFor streamTask: URLSessionStreamTask) {
        streamTaskOfSessionBetterRouteDiscovered?(streamTask, session)
    }
}


