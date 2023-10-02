//
//  YDResource.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import Foundation
import CoreData

struct YDResource: Codable {
    let publicKey: String?
    let embedded: YDResourceList?
    let name: String
    let created: String
    let publicURL: String?
    let originPath: String?
    let modified: String
    let path, type: String
    let mimeType, md5: String?
    let preview: String?
    let size: Int?
    
    enum CodingKeys: String, CodingKey {
        case publicKey = "public_key"
        case name, created, preview
        case publicURL = "public_url"
        case originPath = "origin_path"
        case modified, path, md5, type
        case mimeType = "mime_type"
        case size
        case embedded = "_embedded"
    }
}
