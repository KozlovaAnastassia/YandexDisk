//
//  TableViewCellViewModel.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import Foundation

final class TableViewCellViewModel {

    var token: String
    
    let name: String
    let date: String
    var size: Int
    let preview: String
    let filePath: String
    let mediaType: String
    let directoryType: String
    let md5: String
    
    var fileData = Data()
    
    var formattedDate: String {
        let createdDate = Date.createDateFromString(dateString: date)
        let dateToShowInCell = Date.createStringFromDate(date: createdDate)
        return dateToShowInCell
    }
    
    var sizeInMegaBytes: String {
        return "\(bytesToMegabytes(size)) MB"
    }
    
    var imageURL: URL {
        if let url = URL(string: preview) {
            return url
        } else {
            return AssetExtractor.createLocalUrl(forImageNamed: "folder")!
        }
    }
    
    init(name: String, date: String, size: Int, preview: String, filePath: String, mediaType: String, directoryType: String, md5: String) {
        self.name = name
        self.date = date
        self.size = size
        self.preview = preview
        self.filePath = filePath
        self.mediaType = mediaType
        self.directoryType = directoryType
        self.token = KeychainManager.shared.getTokenFromKeychain() ?? ""
        self.md5 = md5
    }
    
    
    //MARK: - Helper methods
    
    func bytesToMegabytes(_ bytes: Int) -> Double {
        let megabytes = Double(bytes) / 1048576
        let roundedMegabytes = Double(round(100 * megabytes) / 100)
        return roundedMegabytes
    }
    
    deinit {
        print("deinit from TableViewCellViewModel")
    }
    
}
