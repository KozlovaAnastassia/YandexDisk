//
//  UnknownDetailViewController.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import UIKit

class UnknownDetailViewController: UIViewController {

    var viewModel: DetailViewControllerViewModel?
    
    private let imageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupHierarchy()
        setupLayout()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [weak self] in
            self?.presentUnknownFileAlert(action: {
                self?.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    private func setupViews() {
        if let titleString = viewModel?.cellViewModel?.name, let subtitleString = viewModel?.cellViewModel?.date
        {
            let resultSubtitle = viewModel?.prepareSubtitle(subtitle: subtitleString) ?? "unknown date and time"
            navigationItem.setTitle(title: titleString, subtitle: resultSubtitle)
        }
        view.backgroundColor = .systemBackground
        imageView.backgroundColor = .systemBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "unknown")
        
    }
    
    private func setupHierarchy() {
        view.addSubviews(imageView)
    }
    
    
    private func setupLayout() {
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([ imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          imageView.topAnchor.constraint(equalTo: margins.topAnchor),
          imageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
    }
    
    
    deinit {
        print("deinit from UnknownViewController")
    }
}
