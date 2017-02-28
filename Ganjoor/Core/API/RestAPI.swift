//
//  RestAPI.swift
//  Ganjoor
//
//  Created by Farzad Nazifi on 2/28/17.
//  Copyright © 2017 boon. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireSwiftyJSON
import SwiftyJSON
import PromiseKit

class RESTAPI: NSObject {
    
    // MARK: Setup
    static let shared : RESTAPI = {
        let instance = RESTAPI()
        return instance
    }()
    
    let url = "http://localhost:4003/v1"
    
    private func request(path: String, method: HTTPMethod, parameters: Parameters? = nil, headers: HTTPHeaders? = nil) -> Promise<JSON>{
        return Promise { fulfill, reject in
            Alamofire.request(url + path, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseSwiftyJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    fulfill(value)
                case .failure(let error):
                    reject(error)
                }
            })
        }
    }
    
    
    // MARK: Poets
    func poets() -> Promise<JSON> {
        return request(path: "/poets", method: .get)
    }
    
    func poets(poetid id: String) -> Promise<JSON> {
        return request(path: "/poets/" + id, method: .get)
    }
    
    
    // MARK: Categories
    func category(id: String) -> Promise<JSON> {
        return request(path: "/categories/" + id, method: .get)
    }
    
    func category(poetid id: String) -> Promise<JSON> {
        return request(path: "/categories/byPoet/" + id, method: .get)
    }
    
    
    // MARK: Poems
    func poem(id: String) -> Promise<JSON> {
        return request(path: "/categories/" + id, method: .get)
    }
    
    func poem(categoryid id: String) -> Promise<JSON> {
        return request(path: "/categories/byCategory/" + id, method: .get)
    }
}
