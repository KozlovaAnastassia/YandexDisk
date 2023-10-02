//
//  UIButton + Extensions.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import UIKit

extension UIButton {
    static func customButton(title: String, backgroundColor: UIColor = .systemBackground, titleColor: UIColor = .label, fontSize: CGFloat, radius: CGFloat) -> UIButton {
        let button = UIButton (type: .system)
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = radius
        button.backgroundColor = backgroundColor
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        return button
    }
    
    
    func addRightImage(image: UIImage, offset: CGFloat) {
            self.setImage(image, for: .normal)
            self.imageView?.translatesAutoresizingMaskIntoConstraints = false
//            self.imageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        self.imageView?.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0).isActive = true
        self.imageView?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0).isActive = true
            self.imageView?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset).isActive = true
        }
    
    
    
}
