//
//  ApiRouter.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 19.04.2024.
//

import Foundation
import Alamofire

public enum ApiRouter: URLRequestConvertible {
    
    static let baseURLString = "https://www.thecocktaildb.com/api/json/v1/1"
    
    //MARK: - Catalogs

    case cocktailDetail(id: String)
    case filterCocktailsByAlcoholic(isAlcoholic: Bool)
    
    public func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .cocktailDetail, .filterCocktailsByAlcoholic:
                return .get
            }
        }
        
        let url: URL = {
            let relativePath: String
            switch self {
            case .cocktailDetail(let id):
                relativePath = "/lookup.php?i=\(id)"
            case .filterCocktailsByAlcoholic(let isAlcoholic):
                relativePath = isAlcoholic ? "/filter.php?a=Alcoholic" : "/filter.php?a=Non_Alcoholic"
            }
            return URL(string: ApiRouter.baseURLString + relativePath)!
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}
