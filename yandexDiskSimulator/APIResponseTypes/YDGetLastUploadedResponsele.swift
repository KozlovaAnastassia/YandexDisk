//
//  YDGetLastUploadedResponsele.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import Foundation

struct YDGetLastUploadedResponse: Codable {
    let items: [YDResource]
    let limit: Int
}
