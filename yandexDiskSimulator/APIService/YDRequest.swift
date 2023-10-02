//
//  YDRequest.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 18.09.2023.
//

import Foundation

final class YDRequest {
    
    struct Constants {
        static let baseUrl = "https://cloud-api.yandex.net/v1/disk/"
    }
    
    let endpoint: YDEndpoint
    
    // Path components for API, if any
    private let pathComponents: [String]
    // Query arguments for API, if any
    private let queryParameters: [URLQueryItem]
    
    private var urlString: String {
        var string = Constants.baseUrl + endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach {
                string += "/\($0)"
            }
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            
            string += argumentString
        }
        guard let resultURL = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return string }
        
        return resultURL
    }
    //    computed & constructed API url
    public var url: URL? {
        return URL(string: urlString)
    }
    //desired http method
    public var httpMethod = ""
    
    //construct request
    public init(endpoint: YDEndpoint,
                httpMethod: String,
                pathComponents: [String] = [],
                queryParameters: [URLQueryItem] = []) {
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
        self.endpoint = endpoint
        self.httpMethod = httpMethod
    }
    
}

extension YDRequest {
    static let lastUploadedRequest = YDRequest(endpoint: .lastUploaded, httpMethod: "GET", pathComponents: [], queryParameters: [URLQueryItem(name: "limit", value: "200")])
    static let getPublicFilesRequest = YDRequest(endpoint: .publicFiles, httpMethod: "GET")
    static let getDiskDataRequest = YDRequest(endpoint: .empty, httpMethod: "GET")
}


