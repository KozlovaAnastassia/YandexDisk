//
//  UINavigationItem + Extensions.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//
import UIKit

extension UINavigationItem {
    func setTitle(title:String, subtitle:String) {
        
        let one = UILabel()
        one.text = title
        one.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        one.textColor = .label
        one.sizeToFit()
        
        let two = UILabel()
        two.text = subtitle
        two.font = UIFont.systemFont(ofSize: 14, weight: .light)
        two.textAlignment = .center
        two.textColor = .label.withAlphaComponent(0.8)
        two.sizeToFit()
        
        let stackView = UIStackView(arrangedSubviews: [one, two])
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        stackView.alignment = .center
        
        let width = max(one.frame.size.width, two.frame.size.width)
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 35)
        
        one.sizeToFit()
        two.sizeToFit()
        
        self.titleView = stackView
    }
}
