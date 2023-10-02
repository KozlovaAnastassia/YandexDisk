//
//  YDTableViewCell.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import UIKit

class YDTableViewCell: UITableViewCell {
    
    private var viewModel: TableViewCellViewModel?

    var downloadButtonPressed: () -> Void = {}

    let nameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Inter-Regular", size: 16)
        label.textAlignment = .left
        label.textColor = .label
        label.backgroundColor = .systemBackground
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Inter-Regular", size: 14)
        label.textAlignment = .left
        label.backgroundColor = .systemBackground
        label.textColor = .label.withAlphaComponent(0.6)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let sizeLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Inter-SemiBold", size: 14)
        label.textAlignment = .left
        label.backgroundColor = .systemBackground
        label.textColor = .label.withAlphaComponent(0.6)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let cellImageView: ImageLoader = {
       let imageView = ImageLoader()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let savedFileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "mark.unsaved")
        return imageView
    }()
    
    let downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "settings"), for: .normal)
        button.addTarget(self, action: #selector(tappedDownload), for: .touchUpInside)
        return button
    }()


    override init(style: UITableViewCell.CellStyle,
        reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier:
        reuseIdentifier)
        setupViews()
        setupHierarchy()
        setupLayout()
    }
     
       required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }

    func update(with viewModel: TableViewCellViewModel) {
        self.viewModel = viewModel
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.formattedDate
        sizeLabel.text = viewModel.sizeInMegaBytes
        self.cellImageView.loadImageWithUrl(viewModel.imageURL, viewModel.token)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.image = nil
        savedFileImageView.image = nil
        nameLabel.text = nil
        dateLabel.text = nil
    }
    
    private func setupViews() {
        contentView.backgroundColor = .systemBackground
       
        cellImageView.layer.masksToBounds = true
        cellImageView.layer.cornerRadius = 5
    }
    
    private func setupHierarchy() {
        contentView.addSubviews(cellImageView, nameLabel, dateLabel, sizeLabel, downloadButton, savedFileImageView)
    }
    
    private func setupLayout() {
        let margins = contentView.readableContentGuide
        
        NSLayoutConstraint.activate([
            cellImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            cellImageView.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
            cellImageView.heightAnchor.constraint(equalToConstant: 50),
            cellImageView.widthAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: margins.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: downloadButton.leadingAnchor, constant: -5),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            sizeLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -24),
            sizeLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            
            downloadButton.heightAnchor.constraint(equalToConstant: 30),
            downloadButton.widthAnchor.constraint(equalToConstant: 30),
            downloadButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -24),
            downloadButton.bottomAnchor.constraint(equalTo: sizeLabel.topAnchor, constant: -5),
            
            savedFileImageView.bottomAnchor.constraint(equalTo: sizeLabel.bottomAnchor),
            savedFileImageView.trailingAnchor.constraint(equalTo: sizeLabel.leadingAnchor, constant: -5),
            savedFileImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            savedFileImageView.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    @objc private func tappedDownload() {
        downloadButtonPressed()
    }
    
    
}

