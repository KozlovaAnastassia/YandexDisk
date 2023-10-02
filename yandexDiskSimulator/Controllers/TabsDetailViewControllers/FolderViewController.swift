//
//  FolderViewController.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 17.09.2023.
//

import UIKit

final class FolderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var dataViewModel: TableViewCellViewModel?
    var allFilesViewModel: AllFilesViewModel?
    var publishedFilesViewModel: PublishedFilesViewModel?
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.register(YDTableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        setupViews()
        setupHierarchy()
        setupLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(filesDidChanged(_:)), name: NSNotification.Name("filesDidChange"), object: nil)
        
        allFilesViewModel?.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                if self?.allFilesViewModel?.cellViewModels.count == 0 {
                    self?.showNoFilesLabel()
                }
                self?.tableView.reloadData()
            }
        }
        
        guard let path = dataViewModel?.filePath else { return }
        
        allFilesViewModel?.fetchDirectoryFiles(path)
        
        allFilesViewModel?.refreshTableView = { [weak self] in
            self?.allFilesViewModel?.cellViewModels.removeAll()
            DispatchQueue.main.async {
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }
        }
        
    }
    
    
    @objc func filesDidChanged(_ notification: Notification) {
        guard let path = dataViewModel?.filePath else { return }
        
        allFilesViewModel?.cellViewModels.removeAll()
        allFilesViewModel?.fetchDirectoryFiles(path)
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = dataViewModel?.name
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        activityIndicator.color = .darkGray
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func setupHierarchy() {
        view.addSubviews(tableView, activityIndicator)
    }
    
    private func setupLayout() {
        tableView.pinToSuperviewEdges()
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! YDTableViewCell
        guard let viewModel = allFilesViewModel?.cellViewModels[indexPath.row] else { return cell }
        cell.update(with: viewModel)
        
        YDService.shared.downloadFile(path: viewModel.filePath) { downloadResponse in
                // setting up the local cache URL
                let localCacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                // setting up the local cache file URL to the file itself using unique ID - md5
                let localFileURL = localCacheURL.appendingPathComponent(viewModel.md5)
                DispatchQueue.global().async {
                    if let downloadFileURL = URL(string: downloadResponse.href) {
                        let data = try? Data(contentsOf: downloadFileURL)
                        DispatchQueue.main.async {
                            do {
                                try? data?.write(to: localFileURL)
                            }
                        }
                        let filePath = localFileURL.path
                        if let dataToSave = data {
                            //таким образом по адресу localFileURL.path будет лежать файл с уникальным идентификатором md5 и данными dataToSave
                            YDService.shared.moveItemToLocalStorage(filePath: filePath, data: dataToSave)
                    }
                }
            }
        }
        
        cell.downloadButtonPressed = {
            print("download button tapped")
        }
        cell.selectionStyle = .default
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFilesViewModel?.cellViewModels.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let viewModelToPass = allFilesViewModel?.cellViewModels[indexPath.row] else { return }
        guard let mediaType = allFilesViewModel?.cellViewModels[indexPath.row].mediaType else { return }
        
        guard let dirType = allFilesViewModel?.cellViewModels[indexPath.row].directoryType else { return }
        
        allFilesViewModel?.didSelectRowAtDirectoryViewController(with: viewModelToPass, fileType: mediaType, directoryType: dirType)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard !allFilesViewModel!.isLoadingMoreData,
              !allFilesViewModel!.cellViewModels.isEmpty
        else {
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            guard let path = self?.dataViewModel?.filePath else { return }
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight) {
                self?.allFilesViewModel?.fetchAdditionalDirectoryFiles(path)
            }
            t.invalidate()
        }
    }
    
    @objc func didPullToRefresh() {
        guard let path = dataViewModel?.filePath else { return }
        allFilesViewModel?.reFetchDirectoryData(path)
    }
    
    
}
