//
//  UITableView+Extensions.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import UIKit

extension UITableView {
    
  func showLoadingFooter() {
      
      let spinner = UIActivityIndicatorView(style: .medium)
      spinner.startAnimating()
      spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.bounds.width, height: CGFloat(44))
      
      self.tableFooterView = spinner
      self.tableFooterView?.isHidden = false
  }
    
    func hideLoadingFooter() {
        self.tableFooterView?.isHidden = true
        self.tableFooterView = nil
    }
    
}
