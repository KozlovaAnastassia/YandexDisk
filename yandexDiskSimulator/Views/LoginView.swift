//
//  ViewController.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import UIKit

class LoginView: UIView {
    
   private lazy var margins = safeAreaLayoutGuide

    var onButtonTap: (() -> Void)?
    
// MARK: - Views

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Vector")
        return imageView
    }()

    
    private let skillboxLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .center
        
        let attributes1: [NSMutableAttributedString.Key: Any] = [
            .font: UIFont(name: "Inter-ExtraBold", size: 30) as Any,
            .foregroundColor: UIColor.label
        ]
        
        let attributes2: [NSMutableAttributedString.Key: Any] = [
            .font: UIFont(name: "Inter-Regular", size: 30) as Any,
            .foregroundColor: UIColor.label
        ]
        
        let string = Constants.Text.skillboxDrive
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: string)
        
        if let spaceIndex = string.firstIndex(of: " ") {
            attributedString.addAttributes(attributes1,range: NSRange(string.startIndex..<spaceIndex, in: string));
            
            attributedString.addAttributes(attributes2,range: NSRange(spaceIndex..<string.endIndex, in: string))
        }
        label.attributedText = attributedString
        return label
    }()
    
    private lazy var labelStack: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [logoImageView, skillboxLabel])
        stackView.spacing = 29
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton (type: .system)
        button.setTitle(Constants.Text.loginViewButton, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(named: "EnterButton") ?? .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(onButtonTapHandler), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var commonConstraints: [NSLayoutConstraint] = {
        return [
            labelStack.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            loginButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 27),
            margins.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor, constant: 27),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ]
    }()
    
    private lazy var regularConstraints: [NSLayoutConstraint] = {
       return [
        labelStack.topAnchor.constraint(equalTo: margins.topAnchor, constant: 250),
        margins.bottomAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 92)
       ]
    }()
    
    private lazy var compactConstraints: [NSLayoutConstraint] = {
        return [
            labelStack.topAnchor.constraint(equalTo: margins.topAnchor, constant: 80),
            margins.bottomAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 35)
        ]
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

   
    private func setupView() {
        addSubview(labelStack)
        addSubview(loginButton)
        backgroundColor = .systemBackground
        NSLayoutConstraint.activate(commonConstraints)
        configureView(for: traitCollection)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass {
            configureView(for: traitCollection)
        }
    }
    
    private func configureView(for traitCollection: UITraitCollection) {
        if traitCollection.verticalSizeClass == .compact {
            NSLayoutConstraint.deactivate(regularConstraints)
            NSLayoutConstraint.activate(compactConstraints)
        } else {
            NSLayoutConstraint.deactivate(compactConstraints)
            NSLayoutConstraint.activate(regularConstraints)
        }
    }
    
    @objc private func onButtonTapHandler() {
        onButtonTap?()
    }
    
}
