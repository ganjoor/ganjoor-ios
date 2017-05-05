//
//  GanjoorProvider.swift
//  Ganjoor
//
//  Created by Farzad Nazifi on 3/9/17.
//  Copyright © 2017 boon. All rights reserved.
//

import Foundation
import Moya
import PromiseKit
import SwiftyJSON

let GanjoorProvider = MoyaProvider<Ganjoor>(endpointClosure: endpointClosure)

let endpointClosure = { (target: Ganjoor) -> Endpoint<Ganjoor> in
    let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
    return defaultEndpoint.adding(newHTTPHeaderFields: ["Authorization": "Barear eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2Nlc3NMZXZlbCI6ImRldmVsb3BlciJ9.H_XlnExi7eAv3cjfJrxtyVcUYDuntoKB3cvEuopsrhc"])
}

enum Ganjoor {
    case poets(offset: Int)
    case poet(id: String)
    case categories(offset: Int)
    case category(id: Int)
    case topCategories
    case categoriesByPoet(id: Int)
    case categoryByName(name: String)
    case poem(id: Int)
    case poemByCategory(id: Int)
    case versesByPoem(id: Int)
}

enum ProviderError: Swift.Error{
    case networkError(code: Int)
}

extension Ganjoor: TargetType {
    
    var baseURL: URL {
        return URL(string: "http://localhost:7080")!
    }
    
    var path: String {
        switch self {
        case .poets:
            return "/poets"
        case .poet(_):
            return "/poets/"
        case .categories:
            return "/categories"
        case .category(_):
            return "/categories/"
        case .topCategories:
            return "/topCategories"
        case .categoriesByPoet(_):
            return "/categories/byPoet/"
        case .categoryByName(_):
            return "/categories/byName/"
        case .poem(_):
            return "/poems/"
        case .poemByCategory(_):
            return "/poems/byCategory/"
        case .versesByPoem(_):
            return "/verses/byPoem/"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .poets(let offset), .categories(let offset):
            var params: [String: Any] = [:]
            params["offset"] = offset
            return params
        case .categoriesByPoet(let id), .poemByCategory(let id), .versesByPoem(let id), .category(let id):
            var params: [String: Any] = [:]
            params["id"] = id
            return params
        case .categoryByName(let name):
            var params: [String: Any] = [:]
            params["name"] = name
            return params
        default:
            return nil
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .request
    }
}

extension MoyaProvider {
    
    public typealias ResultPromise = Promise<JSON>
    
    public func requestPromise(target: Target, queue: DispatchQueue? = nil, progress: Moya.ProgressBlock? = nil) -> ResultPromise {
        return requestPromiseWithCancellable(target: target, queue: queue, progress: progress).promise
    }
    
    func requestPromiseWithCancellable(target: Target, queue: DispatchQueue?, progress: Moya.ProgressBlock? = nil) -> (promise:ResultPromise, cancellable:Cancellable) {
        let pending = ResultPromise.pending()
        return (pending.promise, self.request(target, queue: queue, progress: progress, completion: self.promiseCompletion(fulfill: pending.fulfill, reject: pending.reject)))
    }
    
    private func promiseCompletion(fulfill: @escaping (JSON) -> Void, reject: @escaping (Swift.Error) -> Void) -> Moya.Completion {
        return { result in
            switch result {
            case let .success(response):
                fulfill(JSON(data: response.data))
            case let .failure(error):
                reject(error)
            }
        }
    }
}
