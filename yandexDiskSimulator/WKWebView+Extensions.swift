//
//  WKWebView+Extensions.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import Foundation
import WebKit

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
    
    func clean() {
            guard #available(iOS 9.0, *) else {return}

            HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)

            WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                records.forEach { record in
                    WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                    #if DEBUG
                        print("WKWebsiteDataStore record deleted:", record)
                    #endif
                }
            }
        }
    
}
