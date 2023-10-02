//
//  LastUploadedViewController.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import UIKit
import Network

class LastUploadedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, NetworkCheckObserver {
   
    let userDefaults = UserDefaults.standard
    
    var networkCheck = NetworkCheck.sharedInstance()
    
    var viewModel: LastUploadedViewModel?
    
    let `label` = UILabel()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.register(YDTableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var savedFiles = [YandexDiskItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if networkCheck.currentStatus == .satisfied {
            //Do something
            activityIndicator.startAnimating()
            viewModel?.fetchFiles()
            viewModel?.fetchFilesFromCoreData()
        } else {
            //Show no network alert
            self.showNoConnectionLabel(label)
            viewModel?.fetchFilesFromCoreData()
        }
        networkCheck.addObserver(observer: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(filesDidChanged(_:)), name: NSNotification.Name("filesDidChange"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCellBookmarks(_:)), name: NSNotification.Name("updateBookmarks"), object: nil)
       
        // Do any additional setup after loading the view.
        setupViews()
        setupHierarchy()
        setupLayout()
        
        viewModel?.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
            }
        }
        
        viewModel?.refreshTableView = { [weak self] in
            self?.viewModel?.cellViewModels.removeAll()
            DispatchQueue.main.async {
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }
        }
        
    }
    
//        MARK: - Change of Network Status

    func statusDidChange(status: NWPath.Status) {
            if status == .satisfied {
                       //Do something
                self.removeNoConnectionLabel(label)
                
                NSLayoutConstraint.deactivate(offlineConstraints)
                NSLayoutConstraint.activate(onlineConstraints)
                
                viewModel?.cellViewModels.removeAll()
                viewModel?.fetchFiles()
            } else if status == .unsatisfied {
                //Show no network alert
                
                NSLayoutConstraint.deactivate(onlineConstraints)
                NSLayoutConstraint.activate(offlineConstraints)
                
                self.showNoConnectionLabel(label)
                viewModel?.cellViewModels.removeAll()
                viewModel?.fetchFilesFromCoreData()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }
        
    //        As you turn on wifi, It notify for NWPath update but until then connection has not been established, it takes some moment to connect
    //        The pathUpdateHandler does not work properly in an iOS simulator but works as expected on a real device.
    
    @objc func filesDidChanged(_ notification: Notification) {
        viewModel?.cellViewModels.removeAll()
        viewModel?.fetchFiles()
    }
    
    @objc func updateCellBookmarks(_ notification: Notification) {
        self.tableView.reloadData()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = Constants.Text.lastUploadedScreenTitle
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
    
    //   MARK: - Constraints
        
        private lazy var commonConstraints: [NSLayoutConstraint] = {
            return [
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ]
        }()
    
    private lazy var onlineConstraints: [NSLayoutConstraint] = {
       return [
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
       ]
    }()
    
    private lazy var offlineConstraints: [NSLayoutConstraint] = {
       return [
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
       ]
    }()
    
    private func setupLayout() {
    
        NSLayoutConstraint.activate(commonConstraints)
        if networkCheck.currentStatus == .satisfied {
            NSLayoutConstraint.activate(onlineConstraints)
        } else {
            NSLayoutConstraint.activate(offlineConstraints)
        }
    
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? YDTableViewCell else {
            return UITableViewCell()
        }
        
        
        if networkCheck.currentStatus == .satisfied {
            if let viewModel = viewModel?.cellViewModels[indexPath.row] {
                cell.update(with: viewModel)
                
               if CoreDataManager.shared.checkIfItemExist(md5: viewModel.md5) {
                        cell.savedFileImageView.image = UIImage(named: "mark.saved")
                    } else {
                        cell.savedFileImageView.image = UIImage(named: "mark.unsaved")
                    }
                
                //MARK: Кеширование по мере презентации ячеек таблицы - позволяет мгновенно открывать картинки и pdf-файлы (не ожидяя каждый раз скачивания в детальном контроллере)
                
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
                // MARK: отработка нажатия на кнопку в ячейке
                
                cell.downloadButtonPressed = { [weak self] in
                    let group = DispatchGroup()
                    
                    if !CoreDataManager.shared.checkIfItemExist(md5: viewModel.md5) {
                        
                        self?.presentLastUploadedSaveFileAlert(title: "\(viewModel.name)", action: {
                            if let label = self?.label {
                                self?.showSaveLabel(label)
                            }
                            //отправить запрос на скачивание файла (как перед открытием детального VC)
                            YDService.shared.downloadFile(path: viewModel.filePath, completion: { linkResponse in
                                //из полученного ответа извлекаем ссылку для скачивания файла и скачиваем в виде Data
                                DispatchQueue.main.async {
                                    guard let url = URL(string: linkResponse.href) else { return }
                                    DispatchQueue.global().async {
                                        group.enter()
                                        let data = try? Data(contentsOf: url)
                                        group.leave()
                                        DispatchQueue.main.async {
                                            group.enter()
                                            viewModel.fileData = data ?? Data()
                                            group.leave()
                                            //данные файла сохраняются в формате Data() и далее готовы к сохранению в один из аттрибутов YandexDiskItem - fileData (полученные данные будем использовать для показа файла в детальном просмотре offline)
                                            let previewImageData = cell.cellImageView.image?.pngData()
                                            //Сохранить вьюмодель данной ячейки в CoreData
                                            //в случае, если такой еще нет в Core Data
                                            
                                            group.notify(queue: .main) {
                                                if let label = self?.label {
                                                    self?.removeSaveLabel(label)
                                                }
                                                self?.viewModel?.saveFileToCoreData(viewModel, previewImageData)
                                                //отправляем уведомление через NotificationCenter, чтобы все контроллеры обновили закладку сохранения файла в своих таблицах
                                                NotificationCenter.default.post(name: NSNotification.Name("updateBookmarks"), object: nil)
                                                //Показать картинку закладку сохранения файла в cell.savedFileImageView
                                                cell.savedFileImageView.image = UIImage(named: "mark.saved")
                                            }
                                            
                                        }
                                    }
                                }
                            })
                        })
                    } else {
                        //если уже есть файл в кордате, то показать алерт удаления из избранных
                        self?.presentLastUploadedDeleteFileAlert(title: "\(viewModel.name)", action: {
                            if let itemToDelete = CoreDataManager.shared.getItemFromStorageWithID(viewModel.md5) {
                                CoreDataManager.shared.deleteItem(itemToDelete)
                                NotificationCenter.default.post(name: NSNotification.Name("updateBookmarks"), object: nil)
                                cell.savedFileImageView.image = UIImage(named: "mark.unsaved")
                            }
                        })
                    }
                }
            }
            // если отсутствует интернет, то будут показываться файлы из избранного
        } else {
            if let viewModel = viewModel?.savedInCoreDataFiles[indexPath.row] {
                cell.nameLabel.text = viewModel.name
                cell.sizeLabel.text = viewModel.size
                cell.dateLabel.text = viewModel.created
                if let data = viewModel.image {
                    cell.cellImageView.image = UIImage(data: data)
                }
                cell.savedFileImageView.image = UIImage(named: "mark.saved")
                cell.downloadButtonPressed = {
                    self.presentOfflineAlert()
                }
            }
        }
           
        cell.selectionStyle = .default
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if networkCheck.currentStatus == .satisfied {
            return viewModel?.cellViewModels.count ?? 0
        } else {
            return viewModel?.savedInCoreDataFiles.count ?? 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if networkCheck.currentStatus == .satisfied {
            guard let viewModelToPass = viewModel?.cellViewModels[indexPath.row] else { return }
            guard let mediaType = viewModel?.cellViewModels[indexPath.row].mediaType else { return }
            viewModel?.didSelectRow(with: viewModelToPass, fileType: mediaType)
        } else {
            guard let viewModelToPass = viewModel?.savedInCoreDataFiles[indexPath.row] else { return }
            guard let mediaType = viewModel?.savedInCoreDataFiles[indexPath.row].mediaType else { return }
            viewModel?.didSelectRowOffline(with: viewModelToPass, fileType: mediaType)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard !viewModel!.isLoadingMoreData,
              !viewModel!.cellViewModels.isEmpty
        else {
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight) {
                self?.viewModel?.fetchAdditionalFiles()
            }
            t.invalidate()
        }
    }
    
    @objc func didPullToRefresh() {
        viewModel?.reFetchData()
    }
    
}

