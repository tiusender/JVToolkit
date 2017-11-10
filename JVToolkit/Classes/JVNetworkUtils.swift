//
//  JVNetworkUtils.swift
//  Pods
//
//  Created by Jorge Villalobos Beato on 11/30/16.
//
//

import Foundation
import Reachability
import SwiftyJSON
import AEXML
import SwiftyUserDefaults

public enum BackendError:Error{
    case noNetwork
    case notLoggedIn
    case apiError
    case incorrectArguments
    case emptyData
    case errorStatusCode
    case jsonParsingError
    case xmlParsingError
}

public enum JVResult<T>:CustomStringConvertible {
    case Success(T)
    case Failure(Error)
    
    func map<P>(f: (T) -> P) -> JVResult<P> {
        switch self {
        case .Success(let value):
            return .Success(f(value))
            break
        case .Failure(let error):
            return .Failure(error)
            break
        }
    }
    
    public func value() -> T? {
        switch self {
        case .Success(let value):
            return value
            break
        case .Failure(let error):
            return nil
            break
        }
    }
    
    public func error() -> Error? {
        switch self {
        case .Success(let value):
            return nil
            break
        case .Failure(let error):
            return error
            break
        }
    }
    
    public var description:String {
        switch self {
        case .Success(let value):
            return String(describing: value)
            break
        case .Failure(let error):
            return String(describing:error)
            break
        }
    }
}

public class JVNetworkUtils:NSObject,URLSessionDelegate {
    public static let sharedInstance : JVNetworkUtils = JVNetworkUtils()
}

//JSON
extension JVNetworkUtils {
    public class func processJSONData<T>(_ data:Data, process:(JSON)->JVResult<T>) -> JVResult<T> {
        do {
            let json = try JSON(data: data)
            let item = process(json)
            
            return item
        } catch {
            return JVResult.Failure(BackendError.jsonParsingError)
        }
    }
    
    public class func processData<T>(result:JVResult<Data>, completion:@escaping (_ result:JVResult<T>) -> Void, jsonProcessing:(JSON)->JVResult<T>) -> Void
    {
        switch result {
        case .Failure(let error):
            completion(JVResult.Failure(error))
            break
        case .Success(let data):
            completion(JVNetworkUtils.processJSONData(data, process: jsonProcessing))
            break
        }
    }
    
    public class func processData<T>(result:JVResult<Data>,
                                  jsonParser:(JSON)->JVResult<T>,
                                  completion:@escaping (_ result:JVResult<T>) -> Void) -> Void
    {
        switch result {
        case .Failure(let error):
            completion(JVResult.Failure(error))
            break
        case .Success(let data):
            completion(JVNetworkUtils.processJSONData(data, process: jsonParser))
            break
        }
    }
}

//XML
extension JVNetworkUtils {
    public class func processXMLData<T>(_ data:Data, process:(AEXMLDocument)->JVResult<T>) -> JVResult<T> {
        do {
            let xmlDoc = try AEXMLDocument(xml: data)
            return process(xmlDoc)
        } catch {
            return JVResult.Failure(BackendError.xmlParsingError)
        }
    }
    
    public class func processData<T>(result:JVResult<Data>, completion:@escaping (_ result:JVResult<T>) -> Void, xmlProcessing:(AEXMLDocument)->JVResult<T>) -> Void
    {
        switch result {
        case .Failure(let error):
            completion(JVResult.Failure(error))
            break
        case .Success(let data):
            completion(JVNetworkUtils.processXMLData(data, process: xmlProcessing))
            break
        }
    }
    
    public class func processData<T>(result:JVResult<Data>,
                                  xmlParser:(AEXMLDocument)->JVResult<T>,
                                  completion:@escaping (_ result:JVResult<T>) -> Void) -> Void
    {
        switch result {
        case .Failure(let error):
            completion(JVResult.Failure(error))
            break
        case .Success(let data):
            completion(JVNetworkUtils.processXMLData(data, process: xmlParser))
            break
        }
    }
}

//Networking
extension JVNetworkUtils {
    
    public class func loadData(fromUrlString: String, urlRequest: URLRequest?=nil,
                               httpMethod: String?="GET", httpBody:String? = nil, httpHeaders: Dictionary<String, String>?=nil,
                               completion:@escaping (_ result:JVResult<Data>) -> Void) -> URLSessionDataTask?
    {
        var externalReachability:Reachability?
        
        let this = JVNetworkUtils.sharedInstance
        var task:URLSessionDataTask? = nil
        
        do {
            externalReachability = try Reachability()!
            
            var hasNetworkConnection = false
            
            if let externalReachability = externalReachability, externalReachability.isReachable {
                hasNetworkConnection = true
            }
            
            if Defaults.hasKey(.localDebug) || hasNetworkConnection {
                let configuration = URLSessionConfiguration.default
                let session = Foundation.URLSession(configuration: configuration, delegate: this, delegateQueue:OperationQueue.main)
                
                var finalUrlRequest = urlRequest ?? URLRequest(url: URL(string: fromUrlString)!) as URLRequest
                
                finalUrlRequest.cachePolicy = .reloadIgnoringLocalCacheData
                finalUrlRequest.httpMethod = httpMethod!
                
                if let safeHttpHeaders = httpHeaders
                {
                    for (headerName, headerValue) in safeHttpHeaders
                    {
                        finalUrlRequest.setValue(headerValue, forHTTPHeaderField: headerName)
                    }
                }
                
                if let httpBody = httpBody
                {
                    if httpBody != "" {
                        finalUrlRequest.httpBody = httpBody.data(using: String.Encoding.utf8);
                    }
                }
                
                task = self.dataTask(session, request:finalUrlRequest, completion:completion)
            } else {
                completion(JVResult.Failure(BackendError.noNetwork))
            }
        } catch _ {
            completion(JVResult.Failure(BackendError.noNetwork))
        }
        
        return task
    }
    
    public class func dataTask(_ withSession:URLSession, request:URLRequest, completion:@escaping (_ result:JVResult<Data>) -> Void)
        -> URLSessionDataTask {
            let loadDataTask = withSession.dataTask(with: request, completionHandler: {
                (data: Data?, response: URLResponse?, error: Error?) -> Void in
                
                if let responseError = error
                {
                    completion(JVResult.Failure(responseError))
                }
                else if let httpResponse = response as? HTTPURLResponse
                {
                    if httpResponse.statusCode < 200 && httpResponse.statusCode >= 400
                    {
                        completion(JVResult.Failure(BackendError.errorStatusCode))
                    }
                    else if let data = data
                    {
                        completion(JVResult.Success(data))
                    }
                    else
                    {
                        completion(JVResult.Failure(BackendError.emptyData))
                    }
                }
            })
            
            loadDataTask.resume()
            
            return loadDataTask
    }
    
    func URLSession(_ session: Foundation.URLSession, task: URLSessionTask, didReceiveChallenge challenge: URLAuthenticationChallenge, completionHandler: (Foundation.URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}

//Networking+JSON
extension JVNetworkUtils {
    public class func loadJSON<T>(fromUrlString: String, urlRequest: URLRequest?=nil,
                               httpMethod: String?="GET", httpBody:String? = nil, httpHeaders: Dictionary<String, String>?=nil,
                               completion:@escaping (_ result:JVResult<T>) -> Void,
                               jsonProcessing:@escaping (JSON)->JVResult<T>) -> URLSessionDataTask?
    {
        return JVNetworkUtils.loadData(fromUrlString: fromUrlString, urlRequest: urlRequest, httpMethod: httpMethod, httpBody: httpBody, httpHeaders: httpHeaders) { (JVResult) in
            
            JVNetworkUtils.processData(result: JVResult, completion: completion, jsonProcessing: jsonProcessing)
        }
    }
    
    
    public class func loadJSON<T>(fromUrlString:String, urlRequest:URLRequest? = nil,
                               httpMethod:String? = "GET", httpBody:String? = nil,
                               httpHeaders:Dictionary<String, String>? = nil,
                               jsonParser:@escaping (JSON)->JVResult<T>,
                               completion:@escaping (_ result:JVResult<T>) -> Void)  -> URLSessionDataTask?
    {
        return JVNetworkUtils.loadData(fromUrlString: fromUrlString, urlRequest: urlRequest, httpMethod: httpMethod, httpBody: httpBody, httpHeaders: httpHeaders) { (JVResult) in
            
            JVNetworkUtils.processData(result: JVResult, jsonParser:jsonParser, completion:completion)
        }
    }
}

//Networking+XML
extension JVNetworkUtils {
    public class func loadXML<T>(fromUrlString: String, urlRequest: URLRequest?=nil,
                              httpMethod: String?="GET", httpBody:String? = nil, httpHeaders: Dictionary<String, String>?=nil,
                              completion:@escaping (_ result:JVResult<T>) -> Void,
                              xmlProcessing:@escaping (AEXMLDocument)->JVResult<T>) -> URLSessionDataTask?
    {
        return JVNetworkUtils.loadData(fromUrlString: fromUrlString, urlRequest: urlRequest, httpMethod: httpMethod, httpBody: httpBody, httpHeaders: httpHeaders) { (JVResult) in
            
            JVNetworkUtils.processData(result: JVResult, completion: completion, xmlProcessing: xmlProcessing)
        }
    }
    
    public class func loadXML<T>(fromUrlString:String, urlRequest:URLRequest? = nil,
                               httpMethod:String? = "GET", httpBody:String? = nil,
                               httpHeaders:Dictionary<String, String>? = nil,
                               xmlParser:@escaping (AEXMLDocument)->JVResult<T>,
                               completion:@escaping (_ result:JVResult<T>) -> Void)  -> URLSessionDataTask?
    {
        return JVNetworkUtils.loadData(fromUrlString: fromUrlString, urlRequest: urlRequest, httpMethod: httpMethod, httpBody: httpBody, httpHeaders: httpHeaders) { (JVResult) in
            
            JVNetworkUtils.processData(result: JVResult, xmlParser:xmlParser, completion:completion)
        }
    }
}
