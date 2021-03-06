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

/// Types adopting the `URLConvertible` protocol can be used to construct URLs, which are then used to 
/// construct URL requests.
public protocol URLConvertible {
    /// Returns a URL that conforms to RFC 2396 or throws an `Error`.
    ///
    /// - throws: An `Error` if the type cannot be converted to a `URL`.
    ///
    /// - returns: A URL or throws an `Error`.
    func asURL() throws -> URL
}

/// Types adopting the `URLQueryStringConvertible` protocol can be used to construct URL query strings 
/// like `field1=value1&field2=value2`, which are then used to construct URLs.
public protocol URLQueryStringConvertible {
    func asQuery() throws -> String
}

public protocol RequestResult {
    func response(_ responseHandler: () -> Swift.Void) -> Swift.Void
}

typealias Response = RequestResult

public protocol RequestExecutable {
    
}

/// A type used to define how a set of parameters are applied to a `URLRequest`.
public protocol RequestEncoding {
    /// Creates a URL request by encoding parameters and applying them onto an existing request.
    ///
    /// - parameter request:    The request to have parameters applied.
    /// - parameter parameters: The parameters to apply.
    ///
    /// - throws: An `AFError.parameterEncodingFailed` error if encoding fails.
    ///
    /// - returns: The encoded request.
    func encode(_ request: URLRequestConvertible, with parameters: Request.Parameters?) throws -> URLRequest
}

public final class Request {
    
}

// MARK: - Extensions.

extension Request {
    public final class Results {
        /// Errors occured when request the url resouces.
        public var error: Error?
        /// Task for the request result.
        public var task: Task?
        
        init(task: Task? = nil, error: Error? = nil) {
            self.task = task
            self.error = error;
        }
        
        convenience init(task: TaskConvertible, session: Session) throws {
            self.init()
            self.task = try Task(task.asTask(), session: session)
        }
    }
}

extension Request.Results: RequestResult {
    public func response(_ responseHandler: () -> Void) {
        task?.sessionTask?.resume()
        responseHandler()
    }
}

extension Request {
    public final class Execution {
        
    }
}

extension Request.Execution: RequestExecutable {
    
}

extension Request {
    /// Creates a url-encoded query string to be set as or appended to any existing URL query string or set as the HTTP
    /// body of the URL request. Whether the query string is set or appended to any existing URL query string or set as
    /// the HTTP body depends on the destination of the encoding.
    ///
    /// The `Content-Type` HTTP header field of an encoded request with HTTP body is set to
    /// `application/x-www-form-urlencoded; charset=utf-8`. Since there is no published specification for how to encode
    /// collection types, the convention of appending `[]` to the key for array values (`foo[]=1&foo[]=2`), and appending
    /// the key surrounded by square brackets for nested dictionary values (`foo[bar]=baz`).
    public struct URLEncoding {
        /// Defines whether the url-encoded query string is applied to the existing query string or HTTP body of the
        /// resulting URL request.
        ///
        /// - asMethod: Applies encoded query string result to existing query string for `GET`, `HEAD` and `DELETE`
        ///                    requests and sets as the HTTP body for requests with any other HTTP method.
        /// - asQuery:  Sets or appends encoded query string result to existing query string.
        /// - asBody:   Sets encoded query string result as the HTTP body of the URL request.
        public enum EncodingMethods {
            case asMethod
            case asQuery
            case asBody
            
            fileprivate func shouldEncodeRequestParameters(with method: Request.HTTPMethod) -> Bool {
                switch self {
                case .asQuery:
                    return true
                case .asBody:
                    return false
                default:
                    break
                }
                
                switch method {
                case .get, .head, .delete:
                    return true
                default:
                    return false
                }
            }
        }
        // MARK: Properties.
        
        /// Returns a default `URLEncoding` instance.
        public static var `default`: URLEncoding { return .httpMethod }
        /// Returns a `URLEncoding` instance with a `.asMethod` destination.
        public static var httpMethod: URLEncoding { return URLEncoding() }
        /// Returns a `URLEncoding` instance with a `.asQuery` destination.
        public static var query: URLEncoding { return URLEncoding(encodingMethod: .asQuery) }
        /// Returns a `URLEncoding` instance with an `.URLEncoding` destination.
        public static var httpBody: URLEncoding { return URLEncoding(encodingMethod: .asBody) }
        
        /// The destination defining where the encoded query string is to be applied to the URL request.
        public let encodingMethod: EncodingMethods
        
        // MARK: Initialization.
        
        /// Creates a `URLEncoding` instance using the specified method.
        ///
        /// - parameter destination: The method defining where the encoded query string is to be applied.
        ///
        /// - returns: The new `URLEncoding` instance.
        public init(encodingMethod: EncodingMethods = .asMethod) {
            self.encodingMethod = encodingMethod
        }
    }
}

extension Request.URLEncoding: RequestEncoding {
    /// Creates a URL request by encoding parameters and applying them onto an existing request.
    ///
    /// - parameter urlRequest: The request to have parameters applied.
    /// - parameter parameters: The parameters to apply.
    ///
    /// - throws: An `Error` if the encoding process encounters an error.
    ///
    /// - returns: The encoded request.
    public func encode(_ request: URLRequestConvertible, with parameters: Request.Parameters?) throws -> URLRequest {
        var urlRequest = try request.asURLRequest()
        
        guard let params = parameters else { return urlRequest }
        
        let paramQuery = try params.asQuery()
        
        if let method = Request.HTTPMethod(rawValue: urlRequest.httpMethod ?? "GET"), encodingMethod.shouldEncodeRequestParameters(with: method) {
            guard let url = urlRequest.url else { throw AxziplinError.requestUrlEncodingFailed(reason: .emptyUrl) }
            
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !params.isEmpty {
                let encodedQuery = (urlComponents.percentEncodedQuery.map({ string -> String in return string + "&" }) ?? "") + paramQuery
                urlComponents.percentEncodedQuery = encodedQuery
                urlRequest.url = urlComponents.url
            }
        } else {
            if let _ = urlRequest.value(forHTTPHeaderField: "Content-Type") { } else {
                urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            }
            urlRequest.httpBody = paramQuery.data(using: .utf8, allowLossyConversion: false)
        }
        
        return urlRequest
    }
}

extension Request {
    /// Uses `JSONSerialization` to create a JSON representation of the parameters object, which is set as the body of the
    /// request. The `Content-Type` HTTP header field of an encoded request is set to `application/json`.
    public struct JSONEncoding {
        // MARK: Properties
        
        /// Returns a `JSONEncoding` instance with default writing options.
        public static var `default`: JSONEncoding { return .prettyPrinted }
        /// Returns a `JSONEncoding` instance with `.prettyPrinted` writing options.
        public static var prettyPrinted: JSONEncoding { return JSONEncoding() }
        /// The options for writing the parameters as JSON data.
        private let options: JSONSerialization.WritingOptions
        
        // MARK: Initialization
        
        /// Creates a `JSONEncoding` instance using the specified options.
        ///
        /// - parameter options: The options for writing the parameters as JSON data.
        ///
        /// - returns: The new `JSONEncoding` instance.
        public init(options: JSONSerialization.WritingOptions = .prettyPrinted) {
            self.options = options
        }
    }
}

extension Request.JSONEncoding: RequestEncoding {
    /// Creates a URL request by encoding parameters and applying them onto an existing request.
    ///
    /// - parameter urlRequest: The request to have parameters applied.
    /// - parameter parameters: The parameters to apply.
    ///
    /// - throws: An `Error` if the encoding process encounters an error.
    ///
    /// - returns: The encoded request.
    public func encode(_ request: URLRequestConvertible, with parameters: Request.Parameters?) throws -> URLRequest {
        var urlRequest = try request.asURLRequest()
        
        guard let params = parameters else { return urlRequest }
        guard !params.isEmpty else { return urlRequest }
        
        guard JSONSerialization.isValidJSONObject(params) else { throw AxziplinError.requestUrlEncodingFailed(reason: .invalidJSONObject) }
        
        do {
            let JSONData = try JSONSerialization.data(withJSONObject: params, options: [.prettyPrinted])
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            urlRequest.httpBody = JSONData
        } catch let error {
            throw AxziplinError.requestUrlEncodingFailed(reason: .JSONSerializationFailed(error: error))
        }
        
        return urlRequest
    }
}

extension Request {
    /// Uses `PropertyListSerialization` to create a plist representation of the parameters object, according to the
    /// associated format and write options values, which is set as the body of the request. The `Content-Type` HTTP header
    /// field of an encoded request is set to `application/x-plist`.
    public struct PropertyListEncoding {
        
        // MARK: Properties
        
        /// Returns a default `PropertyListEncoding` instance.
        public static var `default`: PropertyListEncoding { return PropertyListEncoding() }
        /// Returns a `PropertyListEncoding` instance with xml formatting and default writing options.
        public static var xml: PropertyListEncoding { return PropertyListEncoding(format: .xml) }
        /// Returns a `PropertyListEncoding` instance with binary formatting and default writing options.
        public static var binary: PropertyListEncoding { return PropertyListEncoding(format: .binary) }
        /// The property list serialization format.
        public let format: PropertyListSerialization.PropertyListFormat
        /// The options for writing the parameters as plist data.
        public let options: PropertyListSerialization.WriteOptions
        
        // MARK: Initialization
        
        /// Creates a `PropertyListEncoding` instance using the specified format and options.
        ///
        /// - parameter format:  The property list serialization format.
        /// - parameter options: The options for writing the parameters as plist data.
        ///
        /// - returns: The new `PropertyListEncoding` instance.
        public init(format: PropertyListSerialization.PropertyListFormat = .xml, options: PropertyListSerialization.WriteOptions = 0) {
            self.format = format
            self.options = options
        }
    }
}

extension Request.PropertyListEncoding: RequestEncoding {
    /// Creates a URL request by encoding parameters and applying them onto an existing request.
    ///
    /// - parameter urlRequest: The request to have parameters applied.
    /// - parameter parameters: The parameters to apply.
    ///
    /// - throws: An `Error` if the encoding process encounters an error.
    ///
    /// - returns: The encoded request.
    public func encode(_ request: URLRequestConvertible, with parameters: Request.Parameters?) throws -> URLRequest {
        var urlRequest = try request.asURLRequest()
        
        guard let params = parameters else { return urlRequest }
        guard !params.isEmpty else { return urlRequest }
        
        do {
            let plistData = try PropertyListSerialization.data(fromPropertyList: params, format: format, options: options)
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/x-plist", forHTTPHeaderField: "Content-Type")
            }
            
            urlRequest.httpBody = plistData
        } catch {
            throw AxziplinError.requestUrlEncodingFailed(reason: .propertyListSerializationFailed(error: error))
        }
        
        return urlRequest
    }
}

// Type alias Dictionary<String, Any> to RequestParameters.
extension Request {
    public typealias Parameters = [String: Any]
}

extension Request {
    public typealias Headers    = [String: String]
}

// Defines HTTPMethods of HTTP URL Requests.
extension Request {
    public enum HTTPMethod: String {
        case options = "OPTIONS"
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case trace   = "TRACE"
        case connect = "CONNECT"
    }
}

// Conform Dictionary to protocol `URLQueryStringConvertible` to gain chance of cnverting to query string.
extension Dictionary: URLQueryStringConvertible {
    public func asQuery() throws -> String {
        guard let _ = self as? [String: Any] else { throw AxziplinError.invalidParametersKeyType(parameters: self) }
        
        func _query() -> String {
            var components: [(String, String)] = []
            /// Creates percent-escaped, URL encoded query string components from the given key-value pair using recursion.
            ///
            /// - parameter key:   The key of the query component.
            /// - parameter value: The value of the query component.
            ///
            /// - returns: The percent-escaped, URL encoded query string components.
            func _queryValue(fromKey key: String, value: Any) -> [(String, String)] {
                var valueComponents: [(String, String)] = []
                
                switch value {
                case is [String: Any]:
                    let dictionary = value as! [String: Any]
                    for (nestedKey, nestedValue) in dictionary {
                        valueComponents += _queryValue(fromKey: "\(key)[\(nestedKey)]", value: nestedValue)
                    }
                case is [Any]:
                    let array = value as! [Any]
                    for nestedValue in array {
                        valueComponents += _queryValue(fromKey: "\(key)[]", value: nestedValue)
                    }
                case is NSNumber, is Bool:
                    if let number = value as? NSNumber {
                        // Is bool.
                        if CFBooleanGetTypeID() == CFGetTypeID(number) {
                            valueComponents += [(key.escaped, (number.boolValue ? "1" : "0").escaped)]
                        } else {
                            valueComponents += [(key.escaped, "\(number)".escaped)]
                        }
                    } else if let bool = value as? Bool {
                        valueComponents += [(key.escaped, (bool ? "1" : "0").escaped)]
                    }
                default:
                    valueComponents += [(key.escaped, "\(value)".escaped)]
                }
                
                return valueComponents
            }
            
            for (key, value) in self {
                components += _queryValue(fromKey: key as! String, value: value)
            }
            
            return components.map { "\($0)=\($1)" }.joined(separator: "&")
        }
        
        return _query()
    }
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

extension URLQueryStringConvertible {
    public var query: String? { return try? asQuery() }
}
// String to `URLConvertiable`.
extension String: URLConvertible {
    public func asURL() throws -> URL {
        guard let url = URL(string: self) else { throw AxziplinError.invalidURL(url: self) }
        return url
    }
}

extension URL: URLConvertible {
    public func asURL() throws -> URL { return self }
}

extension String {
    /// Returns a percent-escaped string following RFC 3986 for a query string key or value.
    ///
    /// RFC 3986 states that the following characters are "reserved" characters.
    ///
    /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
    ///
    /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    /// should be percent-escaped in the query string.
    ///
    /// - returns: The percent-escaped string.
    fileprivate var escaped: String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        
        //  Batching is required for escaping due to an internal bug in iOS 8.1 and 8.2. Encoding more than a few
        //  hundred Chinese characters causes various malloc error crashes. To avoid this issue until iOS 8 is no
        //  longer supported, batching MUST be used for encoding. This introduces roughly a 20% overhead.
        
        if #available(iOS 8.3, *) {
            escaped = addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? self
        } else {
            let batchSize = 50
            var index = startIndex
            
            while index != endIndex {
                let startIndex = index
                let _endIndex = self.index(index, offsetBy: batchSize, limitedBy: endIndex) ?? endIndex
                let range = startIndex..<_endIndex
                
                let _substring = substring(with: range)
                
                escaped += _substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? _substring
                
                index = _endIndex
            }
        }
        
        return escaped
    }
}
