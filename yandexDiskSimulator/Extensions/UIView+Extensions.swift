//
//  UIView+Extensions.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 13.09.2023.
//

import UIKit

extension UIView {
    
    func createDefaultShadow(for myView: UIView, cornerRadius: CGFloat) {
        myView.layer.shadowColor = UIColor.gray.cgColor
        myView.layer.shadowOffset = CGSize(width: 2, height: 5)
        
        myView.layer.shadowOpacity = 0.5
        myView.layer.shadowRadius = 4.0
        myView.layer.cornerRadius = cornerRadius
        myView.clipsToBounds = false
        myView.layer.masksToBounds = false
    }
    
    func addSubviews(_ views: UIView...) {
            views.forEach { view in
                self.addSubview(view)
            }
        }
    
    enum Edge {
        case left
        case top
        case right
        case bottom
    }
    
    func pinToSuperviewEdges(_ edges: [Edge] = [.top, .bottom, .left, .right], constant: CGFloat = 0) {
        guard let superview = superview else { return }
        edges.forEach {
            switch $0 {
            case .top: topAnchor.constraint(equalTo: superview.topAnchor, constant: constant).isActive = true
            case .left:
                leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant).isActive = true
            case .right:
                trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -constant).isActive = true
            case .bottom:
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -constant).isActive = true
            }
        }
    }
    
}
