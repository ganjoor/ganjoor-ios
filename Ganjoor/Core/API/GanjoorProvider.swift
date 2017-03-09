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

let GanjoorProvider = MoyaProvider<Ganjoor>()

enum Ganjoor {
    case poets
    case poet(id: String)
    case category(id: String)
    case categoryByPost(id: String)
    case poem(id: String)
    case poemByCategory(id: String)
}

enum ProviderError: Swift.Error{
    case networkError(code: Int)
}

extension Ganjoor: TargetType {
    
    var baseURL: URL {
        return URL(string: "http://localhost:4003/v1")!
    }
    
    var path: String {
        switch self {
        case .poets:
            return "/poets"
        case .poet(let id):
            return "/poets/" + id
        case .category(let id):
            return "/categories/" + id
        case .categoryByPost(let id):
            return "/categories/byPoet/" + id
        case .poem(let id):
            return "/categories/" + id
        case .poemByCategory(let id):
            return "/categories/byCategory/" + id
        }
    }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
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
                if  response.statusCode == 200 {
                    fulfill(JSON(data: response.data))
                }else{
                    reject(ProviderError.networkError(code: response.statusCode))
                }
            case let .failure(error):
                reject(error)
            }
        }
    }
}
