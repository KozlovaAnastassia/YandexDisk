//
//  YDGetPublicResourcesListResponse.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import Foundation

struct YDGetPublicResourcesListResponse: Codable {
    let items: [YDResource]
    let type: String?
    let limit: Int
    let offset: Int
    
}
