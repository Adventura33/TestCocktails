//
//  ApiClient.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 19.04.2024.
//

import Foundation
import UIKit
import Alamofire
import RxSwift

public class ApiClient {
    
    private lazy var session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        if #available(iOS 13.0, *) {
            configuration.urlCache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        }
        
        return Session(configuration: configuration)
    }()
    
    public static let shared = ApiClient()
    
    public func request<T:Codable> (_ urlConvertible: URLRequestConvertible, showLoad:Bool = true) -> Observable<T> {
        return Observable.create { observer -> Disposable in
            
            self.session.request(urlConvertible)
                .validate()
                .responseJSON { [weak self] response in
                    guard let self = self else { return }
                    
                    let headers = response.response?.allHeaderFields ?? [:]
                    
                    let statusCode = response.response?.statusCode ?? 0
                    
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error!)
                            return
                        }
                        do {
                            let object = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(object)
                        } catch {
                            observer.onError(error)
                        }
                        
                    case .failure(let error):
                        guard let data = response.data else {
                            observer.onError(response.error!)
                            return
                        }
                        do {
                            let error = try JSONDecoder().decode(T.self, from: data)
                            return
                        } catch {
                            //observer.onError(error)
                        }
                    }
                }
            return Disposables.create()
        }
    }
}
