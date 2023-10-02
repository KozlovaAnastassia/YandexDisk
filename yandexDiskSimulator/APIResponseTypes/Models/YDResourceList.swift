//
//  YDResourceList.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import Foundation

struct YDResourceList: Codable {
    let sort: String
    let publicKey: String?
    let items: [YDResource]
    let path: String
    let limit, offset: Int
    let total: Int?

    enum CodingKeys: String, CodingKey {
        case sort
        case publicKey = "public_key"
        case items, path, limit, offset, total
    }
}
