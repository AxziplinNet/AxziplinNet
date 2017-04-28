//
//  Task.swift
//  AxziplinNet
//
//  Created by devedbox on 2017/4/22.
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

/// Types adopting the `TaskConvertible` protocol can be used to construct URL session tasks.
public protocol TaskConvertible {
    /// Returns a session task or throws if an `Error` was encountered.
    ///
    /// - throws: An `Error` if the underlying `URLSessionTask` is `nil`.
    ///
    /// - returns: A URL session task.
    func asTask() throws -> URLSessionTask
}

public final class Task {
    typealias TaskIdentifier = Int
    /// Get the identifier of the underlying `URLSessionTask` object.
    var identifier: TaskIdentifier { return task.taskIdentifier }
    /// The `Session` object.
    let session: Session
    /// The underlying `URLSessionTask` object.
    let task: URLSessionTask
    
    init(_ task: URLSessionTask, session: Session) {
        self.task = task
        self.session = session
    }
}

// MARK: - Extensions.

extension TaskConvertible {
    var sessionTask: URLSessionTask? { return try? asTask() }
}

extension URLSessionTask: TaskConvertible {
    public func asTask() throws -> URLSessionTask { return self }
}

extension Task: TaskConvertible {
    public func asTask() throws -> URLSessionTask { return task.asTask() }
}
