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
    public var sessionDidBecomeInvalid: ((URLSession, Error?) -> Swift.Void)?
    /// Closure for `urlSession(_:didReceive:completionHandler:)` function in protocol `URLSessionDelegate`.
    public var sessionDidReceiveChallenge: ((URLSession, URLAuthenticationChallenge, (@escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void)) -> Swift.Void)?
    
    /// Closure for `urlSession(_:task:willPerformHTTPRedirection:newRequest:completionHandler:)` function in protocol `URLSessionTaskDelegate`.
    public var taskOfSessionWillPerformHTTPRedirection: ((URLSessionTask, URLSession, HTTPURLResponse, URLRequest, @escaping (URLRequest?) -> Swift.Void) -> Swift.Void)?
    /// Closure for `urlSession(_:task:didReceive:completionHandler:)` function in protocol `URLSessionTaskDelegate`.
    public var taskOfSessionDidReceiveChallenge: ((URLSessionTask, URLSession, URLAuthenticationChallenge, @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) -> Swift.Void)?
    /// Closure for `urlSession(_:task:needNewBodyStream:)` function in protocol `URLSessionTaskDelegate`.
    public var taskOfSessionNeedNewBodyStream: ((URLSessionTask, URLSession, @escaping (InputStream?) -> Swift.Void) -> Swift.Void)?
    /// Closure for `urlSession(_:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:)` function in protocol `URLSessionTaskDelegate`.
    public var taskOfSessionDidSendData: ((URLSessionTask, URLSession, Int64, Int64, Int64) -> Swift.Void)?
    /// Closure for `urlSession(_:task:didFinishCollecting:)` function in protocol `URLSessionTaskDelegate`.
    public var taskOfSessionDidFinishCollecting: ((URLSessionTask, URLSession, URLSessionTaskMetrics) -> Swift.Void)?
    /// Closure for `urlSession(_:task:didComplete:)` function in protocol `URLSessionTaskDelegate`.
    public var taskOfSessionDidComplete: ((URLSessionTask, URLSession, Error?) -> Swift.Void)?
    
    /// Closure for `urlSession(_:dataTask:didReceive:completionHandler:)` function in protocol `URLSessionDataDelegate`.
    public var dataTaskOfSessionDidReceiveResponse: ((URLSessionDataTask, URLSession, URLResponse, @escaping (URLSession.ResponseDisposition) -> Swift.Void) -> Swift.Void)?
    /// Closure for `urlSession(_:dataTask:didBecome:)` function in protocol `URLSessionDataDelegate`.
    public var dataTaskOfSessionDidBecomeDownloadTask: ((URLSessionDataTask, URLSession, URLSessionDownloadTask) -> Swift.Void)?
    /// Closure for `urlSession(_:dataTask:didBecome:)` function in protocol `URLSessionDataDelegate`.
    public var dataTaskOfSessionDidBecomeStreamTask: ((URLSessionDataTask, URLSession, URLSessionStreamTask) -> Swift.Void)?
    /// Closure for `urlSession(_:dataTask:didReceive:)` function in protocol `URLSessionDataDelegate`.
    public var dataTaskOfSessionDidReceiveData: ((URLSessionDataTask, URLSession, Data) -> Swift.Void)?
    /// Closure for `urlSession(_:dataTask:willCacheResponse:)` function in protocol `URLSessionDataDelegate`.
    public var dataTaskOfSessionWillCacheResponse: ((URLSessionDataTask, URLSession, CachedURLResponse, @escaping (CachedURLResponse?) -> Swift.Void) -> Swift.Void)?

    /// Closure for `urlSession(_:downloadTask:didFinishDownloadingTo:)` function in protocol `URLSessionDownloadDelegate`.
    public var downloadTaskOfSessionDidFinishDownloading: ((URLSessionDownloadTask, URLSession, URL) -> Swift.Void)?
    /// Closure for `urlSession(_:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:)` function in protocol `URLSessionDownloadDelegate`.
    public var downloadTaskOfSessionDidWriteData: ((URLSessionDownloadTask, URLSession, Int64, Int64, Int64) -> Swift.Void)?
    /// Closure for `urlSession(_:downloadTask:didResumeAtOffset:expectedTotalBytes:)` function in protocol `URLSessionDownloadDelegate`.
    public var downloadTaskOfSessionDidResume: ((URLSessionDownloadTask, URLSession, Int64, Int64) -> Swift.Void)?
    
    /// Closure for `urlSession(_:readClosedFor:)` function in protocol `URLSessionStreamDelegate`.
    public var streamTaskOfSessionReadClosed: ((URLSessionStreamTask, URLSession) -> Swift.Void)?
    /// Closure for `urlSession(_:writeClosedFor:)` function in protocol `URLSessionStreamDelegate`.
    public var streamTaskOfSessionWriteClosed: ((URLSessionStreamTask, URLSession) -> Swift.Void)?
    /// Closure for `urlSession(_:betterRouteDiscoveredFor:)` function in protocol `URLSessionStreamDelegate`.
    public var streamTaskOfSessionBetterRouteDiscovered: ((URLSessionStreamTask, URLSession) -> Swift.Void)?
    /// Closure for `urlSession(_streamTask:didBecome:outputStream:)` function in protocol `URLSessionStreamDelegate`.
    public var streamTaskOfSessionDidBecomeInOutStream: ((URLSessionStreamTask, URLSession, InputStream, OutputStream) -> Swift.Void)?
    // MARK: URLCredential
    ///
    public var credentialOfChallenge: ((URLSession, URLSessionTask?, URLAuthenticationChallenge) -> URLCredential?)?
}

// MARK: URLSessionDelegate

extension SessionDelegate: URLSessionDelegate {
    /// Tells the URL session that the session has been invalidated.
    /// If you invalidate a session by calling its finishTasksAndInvalidate() method, the session waits until after the final task in the session finishes or fails before calling this delegate method. If you call the invalidateAndCancel() method, the session calls this delegate method immediately.
    /// - Parameters:
    ///   - session: The session object that was invalidated.
    ///   - error:   The error that caused invalidation, or nil if the invalidation was explicit.
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        sessionDidBecomeInvalid?(session, error)
    }
    /// Requests credentials from the delegate in response to a session-level authentication request from the remote server.
    /// This method is called in two situations:
    ///
    /// - When a remote server asks for client certificates or Windows NT LAN Manager (NTLM) authentication,
    ///   to allow your app to provide appropriate credentials
    /// - When a session first establishes a connection to a remote server that uses SSL or TLS,
    ///   to allow your app to verify the server’s certificate chain
    ///
    /// If you do not implement this method, the session calls its delegate’s urlSession(_:task:didReceive:completionHandler:) method instead.
    ///
    /// - Note: This method handles only the NSURLAuthenticationMethodNTLM, NSURLAuthenticationMethodNegotiate,
    ///         NSURLAuthenticationMethodClientCertificate, and NSURLAuthenticationMethodServerTrust authentication types. For all other authentication
    ///         schemes, the session calls only the urlSession(_:task:didReceive:completionHandler:) method.
    /// - Parameters:
    ///   - session: The session containing the task that requested authentication.
    ///   - challenge: An object that contains the request for authentication.
    ///   - completionHandler: A handler that your delegate method must call. Its parameters are:
    ///                        - disposition—One of several constants that describes how the challenge should be handled.
    ///                        - credential—The credential that should be used for authentication if disposition is
    ///                          NSURLSessionAuthChallengeUseCredential, otherwise NULL.
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        // Using did receive challenge closure.
        if let _challenge = sessionDidReceiveChallenge {
            _challenge(session, challenge, completionHandler)
            return
        }
        // Run default configuration of challenge:
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
    }
}

// MARK: URLSessionTaskDelegate

@available(OSX 10.9, *)
extension SessionDelegate: URLSessionTaskDelegate {
    /// Tells the delegate that the remote server requested an HTTP redirect.
    /// This method is called only for tasks in default and ephemeral sessions. Tasks in background sessions automatically follow redirects.
    /// - Parameters:
    ///   - session:           The session containing the task whose request resulted in a redirect.
    ///   - task:              The task whose request resulted in a redirect.
    ///   - response:          An object containing the server’s response to the original request.
    ///   - request:           A URL request object filled out with the new location.
    ///   - completionHandler: A block that your handler should call with either the value of the request parameter, 
    ///                        a modified URL request object, or NULL to refuse the redirect and return the body of the redirect response.
    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Swift.Void) {
        if let willPerformHTTPRedirection = taskOfSessionWillPerformHTTPRedirection {
            willPerformHTTPRedirection(task, session, response, request, completionHandler)
            return;
        }
        
        completionHandler(request)
    }
    /// Requests credentials from the delegate in response to an authentication request from the remote server.
    /// This method handles task-level authentication challenges. The URLSessionDelegate protocol also provides a session-level authentication
    /// delegate method. The method called depends on the type of authentication challenge:
    ///
    /// - For session-level challenges—NSURLAuthenticationMethodNTLM, NSURLAuthenticationMethodNegotiate,
    ///   NSURLAuthenticationMethodClientCertificate, or NSURLAuthenticationMethodServerTrust—the NSURLSession object calls the session
    ///   delegate’s urlSession(_:didReceive:completionHandler:) method. If your app does not provide a session delegate method, the
    ///   NSURLSession object calls the task delegate’s urlSession(_:task:didReceive:completionHandler:) method to handle the challenge.
    /// - For non-session-level challenges (all others), the NSURLSession object calls the session delegate’s  
    ///   urlSession(_:task:didReceive:completionHandler:) method to handle the challenge. If your app provides a session delegate and you need
    ///   to handle authentication, then you must either handle the authentication at the task level or provide a task-level handler that calls
    ///   the per-session handler explicitly. The session delegate’s urlSession(_:didReceive:completionHandler:) method is not called for non-
    ///   session-level challenges.
    ///
    /// - Parameters:
    ///   - session: The session containing the task whose request requires authentication.
    ///   - task: The task whose request requires authentication.
    ///   - challenge: An object that contains the request for authentication.
    ///   - completionHandler: A handler that your delegate method must call. Its parameters are:
    ///                        - disposition—One of several constants that describes how the challenge should be handled.
    ///                        - credential—The credential that should be used for authentication if disposition is
    ///                          NSURLSessionAuthChallengeUseCredential; otherwise, NULL.
    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        taskOfSessionDidReceiveChallenge?(task, session, challenge, completionHandler)
    }
    /// Tells the delegate when a task requires a new request body stream to send to the remote server.
    /// This delegate method is called under two circumstances:
    ///
    /// - To provide the initial request body stream if the task was created with uploadTask(withStreamedRequest:)
    /// - To provide a replacement request body stream if the task needs to resend a request that has a body stream because of an
    ///   authentication challenge or other recoverable server error.
    ///
    /// - Note: You do not need to implement this if your code provides the request body using a file URL or an NSData object.
    /// - Parameters:
    ///   - session:           The session containing the task that needs a new body stream.
    ///   - task:              The task that needs a new body stream.
    ///   - completionHandler: A completion handler that your delegate method should call with the new body stream.
    public func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Swift.Void) {
        if let needNewBodyStream = taskOfSessionNeedNewBodyStream {
            needNewBodyStream(task, session, completionHandler)
            return
        }
        
        completionHandler(nil)
    }
    /// Periodically informs the delegate of the progress of sending body content to the server.
    /// - Parameters:
    ///   - session:                  The session containing the data task.
    ///   - task:                     The data task.
    ///   - bytesSent:                The number of bytes sent since the last time this delegate method was called.
    ///   - totalBytesSent:           The total number of bytes sent so far.
    ///   - totalBytesExpectedToSend: The expected length of the body data. The URL loading system can determine the length of the upload 
    ///                               data in three ways:
    ///                               - From the length of the NSData object provided as the upload body.
    ///                               - From the length of the file on disk provided as the upload body of an upload task (not a download
    ///                                 task).
    ///                               - From the Content-Length in the request object, if you explicitly set it.
    ///                               Otherwise, the value is NSURLSessionTransferSizeUnknown (-1) if you provided a stream or body data
    ///                               object, or zero (0) if you did not.
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        taskOfSessionDidSendData?(task, session, bytesSent, totalBytesSent, totalBytesExpectedToSend)
    }
    /// Tells the delegate that the session finished collecting metrics for the task.
    /// - Parameters:
    ///   - session: The session collecting the metrics.
    ///   - task:    The task whose metrics have been collected.
    ///   - metrics: The collected metrics.
    @available(OSX 10.12, *)
    public func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        taskOfSessionDidFinishCollecting?(task, session, metrics)
    }
    /// Tells the delegate that the task finished transferring data.
    /// Server errors are not reported through the error parameter. The only errors your delegate receives through the error parameter are client-side errors, such as being unable to resolve the hostname or connect to the host.
    /// - Parameters:
    ///   - session: The session containing the task whose request finished transferring data.
    ///   - task:    The task whose request finished transferring data.
    ///   - error:   If an error occurred, an error object indicating how the transfer failed, otherwise NULL.
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        taskOfSessionDidComplete?(task, session, error)
    }
}

// MARK: URLSessionDataDelegate

extension SessionDelegate: URLSessionDataDelegate {
    /// Tells the delegate that the data task received the initial reply (headers) from the server.
    /// This method is optional unless you need to support the (relatively obscure) multipart/x-mixed-replace content type. With that content type, the server sends a series of parts, each of which is intended to replace the previous part. The session calls this method at the beginning of each part, and you should then display, discard, or otherwise process the previous part, as appropriate.
    /// If you do not provide this delegate method, the session always allows the task to continue.
    /// - Parameters:
    ///   - session:           The session containing the data task that received an initial reply.
    ///   - dataTask:          The data task that received an initial reply.
    ///   - response:          A URL response object populated with headers.
    ///   - completionHandler: A completion handler that your code calls to continue the transfer, passing a constant 
    ///                        to indicate whether the transfer should continue as a data task or should become a download task.
    ///                        - If you pass allow, the task continues normally.
    ///                        - If you pass cancel, the task is canceled.
    ///                        - If you pass becomeDownload as the disposition, your delegate’s urlSession(_:dataTask:didBecome:)
    ///                          method is called to provide you with the new download task that supersedes the current task.
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
        if let didReceiveResponse = dataTaskOfSessionDidReceiveResponse {
            didReceiveResponse(dataTask, session, response, completionHandler)
            return
        }
        
        completionHandler(.allow)
    }
    /// Tells the delegate that the data task was changed to a download task.
    /// When the delegate’s URLSession:dataTask:didReceiveResponse:completionHandler: method decides to change the disposition from a data request to a download, the session calls this delegate method to provide you with the new download task. After this call, the session delegate receives no further delegate method calls related to the original data task.
    /// - Parameters:
    ///   - session:      The session containing the task that was replaced by a download task.
    ///   - dataTask:     The data task that was replaced by a download task.
    ///   - downloadTask: The new download task that replaced the data task.
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        dataTaskOfSessionDidBecomeDownloadTask?(dataTask, session, downloadTask)
    }
    /// Tells the delegate that the data task was changed to a streamtask.
    /// When the delegate’s URLSession:dataTask:didReceiveResponse:completionHandler: method decides to change the disposition from a data request to a stream, the session calls this delegate method to provide you with the new stream task. After this call, the session delegate receives no further delegate method calls related to the original data task.
    /// For requests that were pipelined, the stream task will only allow reading, and the object will immediately send the delegate message urlSession(_:writeClosedFor:). Pipelining can be disabled for all requests in a session by setting the httpShouldUsePipelining property on its URLSessionConfiguration object, or for individual requests by setting the httpShouldUsePipelining property on an NSURLRequest object.
    /// - Parameters:
    ///   - session:    The session containing the task that was replaced by a stream task.
    ///   - dataTask:   The data task that was replaced by a stream task.
    ///   - streamTask: The new stream task that replaced the data task.
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
        dataTaskOfSessionDidBecomeStreamTask?(dataTask, session, streamTask)
    }
    /// Tells the delegate that the data task has received some of the expected data.
    /// Because the NSData object is often pieced together from a number of different data objects, whenever possible, use NSData’s enumerateBytes(_:) method to iterate through the data rather than using the bytes method (which flattens the NSData object into a single memory block).
    /// This delegate method may be called more than once, and each call provides only data received since the previous call. The app is responsible for accumulating this data if needed.
    /// - Parameters:
    ///   - session:  The session containing the data task that provided data.
    ///   - dataTask: The data task that provided data.
    ///   - data:     A data object containing the transferred data.
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        dataTaskOfSessionDidReceiveData?(dataTask, session, data)
    }
    /// Asks the delegate whether the data (or upload) task should store the response in the cache.
    /// The session calls this delegate method after the task finishes receiving all of the expected data. If you do not implement this method, the default behavior is to use the caching policy specified in the session’s configuration object. The primary purpose of this method is to prevent caching of specific URLs or to modify the userInfo dictionary associated with the URL response.
    /// This method is called only if the URLProtocol handling the request decides to cache the response. As a rule, responses are cached only when all of the following are true:
    /// - The request is for an HTTP or HTTPS URL (or your own custom networking protocol that supports caching).
    /// - The request was successful (with a status code in the 200–299 range).
    /// - The provided response came from the server, rather than out of the cache.
    /// - The session configuration’s cache policy allows caching.
    /// - The provided NSURLRequest object's cache policy (if applicable) allows caching.
    /// - The cache-related headers in the server’s response (if present) allow caching.
    /// - The response size is small enough to reasonably fit within the cache. (For example, if you provide a disk cache, the response must be    no larger than about 5% of the disk cache size.)
    /// - Parameters:
    ///   - session:           The session containing the data (or upload) task.
    ///   - dataTask:          The data (or upload) task.
    ///   - proposedResponse:  The default caching behavior. This behavior is determined based on the current 
    ///                        caching policy and the values of certain received headers, such as the Pragma and Cache-Control headers.
    ///   - completionHandler: A block that your handler must call, providing either the original proposed response, a modified
    ///                        version of that response, or NULL to prevent caching the response. If your delegate implements this method, 
    ///                        it must call this completion handler; otherwise, your app leaks memory.
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Swift.Void) {
        if let willCacheResponse = dataTaskOfSessionWillCacheResponse {
            willCacheResponse(dataTask, session, proposedResponse, completionHandler)
            return
        }
        
        completionHandler(proposedResponse)
    }
}

// MARK: URLSessionDownloadDelegate

extension SessionDelegate: URLSessionDownloadDelegate {
    /// Tells the delegate that a download task has finished downloading.
    /// - Parameters:
    ///   - session:      The session containing the download task that finished.
    ///   - downloadTask: The download task that finished.
    ///   - location:     A file URL for the temporary file. Because the file is temporary, you must 
    ///                   either open the file for reading or move it to a permanent location in your 
    ///                   app’s sandbox container directory before returning from this delegate method.
    ///
    ///                   If you choose to open the file for reading, you should do the actual reading 
    ///                   in another thread to avoid blocking the delegate queue.
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        downloadTaskOfSessionDidFinishDownloading?(downloadTask, session, location)
    }
    /// Periodically informs the delegate about the download’s progress.
    /// - Parameters:
    ///   - session: The session containing the download task.
    ///   - downloadTask:              The download task.
    ///   - bytesWritten:              The number of bytes transferred since the last time this delegate method was called.
    ///   - totalBytesWritten:         The total number of bytes transferred so far.
    ///   - totalBytesExpectedToWrite: The expected length of the file, as provided by the Content-Length header. 
    ///                                If this header was not provided, the value is NSURLSessionTransferSizeUnknown.
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        downloadTaskOfSessionDidWriteData?(downloadTask, session, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
    }
    /// Tells the delegate that the download task has resumed downloading.
    /// If a resumable download task is canceled or fails, you can request a resumeData object that provides enough information to restart the download in the future. Later, you can call downloadTask(withResumeData:) or downloadTask(withResumeData:completionHandler:) with that data.
    /// When you call those methods, you get a new download task. As soon as you resume that task, the session calls its delegate’s URLSession:downloadTask:didResumeAtOffset:expectedTotalBytes: method with that new task to indicate that the download is resumed.
    /// - Parameters:
    ///   - session:            The session containing the download task that finished.
    ///   - downloadTask:       The download task that resumed. See explanation in the discussion.
    ///   - fileOffset:         If the file's cache policy or last modified date prevents reuse of the existing 
    ///                         content, then this value is zero. Otherwise, this value is an integer representing
    ///                         the number of bytes on disk that do not need to be retrieved again.
    /// - Note:                 In some situations, it may be possible for the transfer to resume earlier in the file 
    ///                         than where the previous transfer ended.
    ///   - expectedTotalBytes: The expected length of the file, as provided by the Content-Length header. If this header 
    ///                         was not provided, the value is NSURLSessionTransferSizeUnknown.
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
    /// Tells the delegate that the stream task has been completed as a result of the stream task calling the captureStreams() method.
    /// This delegate method will only be called after all enqueued reads and writes for the stream task have been completed.
    /// - Parameters:
    ///   - session:      The session of the stream task that has been completed.
    ///   - streamTask:   The stream task that has been completed.
    ///   - inputStream:  The created input stream. This InputStream object is unopened.
    ///   - outputStream: The created output stream. This OutputStream object is unopened
    public func urlSession(_ session: URLSession, streamTask: URLSessionStreamTask, didBecome inputStream: InputStream, outputStream: OutputStream) {
        streamTaskOfSessionDidBecomeInOutStream?(streamTask, session, inputStream, outputStream)
    }
}


