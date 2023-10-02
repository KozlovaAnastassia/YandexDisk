//
//  YDFileLinkResponse.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import Foundation

struct YDFileLinkResponse: Codable {
    let href: String
    let method: String
    let templated: Bool
}
