//
//  PublishedFilesViewController.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 15.09.2023.
//

import UIKit
import Network

class PublishedFilesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NetworkCheckObserver {

    var dataViewModel: TableViewCellViewModel?
    var serviceViewModel: PublishedFilesViewModel?
    
    var networkCheck = NetworkCheck.sharedInstance()
    
    let `label` = UILabel()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.register(YDTableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let noFilesImageView = UIImageView()
    private let noFilesLabel = UILabel()
    
    private let refreshButton = UIButton.customButton(title: Constants.Text.reload, backgroundColor: UIColor(red: 216/255, green: 233/255, blue: 234/255, alpha: 1.0), titleColor: .black, fontSize: 20, radius: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if networkCheck.currentStatus == .satisfied {
            //Do something
            activityIndicator.startAnimating()
            serviceViewModel?.fetchPublishedFiles()
            serviceViewModel?.fetchFilesFromCoreData()
        } else {
            //Show no network alert
            self.showNoConnectionLabel(label)
            
        }
        
        networkCheck.addObserver(observer: self)
        
        setupViews()
        setupHierarchy()
        setupLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(filesDidChanged(_:)), name: NSNotification.Name("filesDidChange"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCellBookmarks(_:)), name: NSNotification.Name("updateBookmarks"), object: nil)
        
        serviceViewModel?.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if self?.serviceViewModel?.cellViewModels.count == 0 {
                        //показать сообщение и картинку об отсутствии опубликованных файлов
                        self?.noFilesImageView.isHidden = false
                        self?.noFilesLabel.isHidden = false
                        self?.refreshButton.isHidden = false
                    }
                }
            }
        }
        
        serviceViewModel?.fetchPublishedFiles()
        
        serviceViewModel?.refreshTableView = { [weak self] in
            self?.serviceViewModel?.cellViewModels.removeAll()
            DispatchQueue.main.async {
                self?.tableView.refreshControl?.endRefreshing()
                if self?.serviceViewModel?.cellViewModels.count == 0 {
                    //показать сообщение и картинку об отсутствии опубликованных файлов
                    self?.noFilesImageView.isHidden = true
                    self?.noFilesLabel.isHidden = true
                    self?.refreshButton.isHidden = true
                }
                self?.tableView.reloadData()
            }
        }
        
        
    }
    

    @objc func filesDidChanged(_ notification: Notification) {
        DispatchQueue.main.async {
            self.noFilesImageView.isHidden = true
            self.noFilesLabel.isHidden = true
            self.refreshButton.isHidden = true
        }
        serviceViewModel?.cellViewModels.removeAll()
        serviceViewModel?.fetchPublishedFiles()
    }
    
    
    @objc func updateCellBookmarks(_ notification: Notification) {
        self.tableView.reloadData()
    }
    
    func statusDidChange(status: NWPath.Status) {
            if status == .satisfied {
                       //Do something
                self.removeNoConnectionLabel(label)
                serviceViewModel?.cellViewModels.removeAll()
                serviceViewModel?.fetchPublishedFiles()
            } else if status == .unsatisfied {
                //Show no network alert
                self.noFilesImageView.isHidden = true
                self.noFilesLabel.isHidden = true
                self.refreshButton.isHidden = true
                self.showNoConnectionLabel(label)
                serviceViewModel?.cellViewModels.removeAll()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }
    
    
    private func setupViews() {
        title = Constants.Text.publishedFiles
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        activityIndicator.color = .darkGray
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        noFilesImageView.translatesAutoresizingMaskIntoConstraints = false
        noFilesImageView.isHidden = true
        noFilesImageView.image = UIImage(named: "folderEmpty")
        noFilesImageView.contentMode = .scaleAspectFit
        
        noFilesLabel.translatesAutoresizingMaskIntoConstraints = false
        noFilesLabel.isHidden = true
        noFilesLabel.text = Constants.Text.haveNopublishedFiles
        noFilesLabel.numberOfLines = 2
        noFilesLabel.textAlignment = .center
        noFilesLabel.textColor = .label
        noFilesLabel.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        
        refreshButton.isHidden = true
        refreshButton.addTarget(self, action: #selector(didPullToRefresh), for: .touchUpInside)
        
        refreshButton.createDefaultShadow(for: refreshButton, cornerRadius: 10)
    }

    
    private func setupHierarchy() {
        view.addSubviews(tableView, activityIndicator, noFilesImageView, noFilesLabel, refreshButton)
    }
    
    
    private func  setupLayout() {
        tableView.pinToSuperviewEdges()
        
        let margins = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            noFilesImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            noFilesImageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            noFilesImageView.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: -50),
            noFilesImageView.heightAnchor.constraint(equalToConstant: view.bounds.size.height / 3),
            
            noFilesLabel.topAnchor.constraint(equalTo: noFilesImageView.bottomAnchor, constant: 20),
            noFilesLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 30),
            noFilesLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -30),
            
            margins.bottomAnchor.constraint(equalTo: refreshButton.bottomAnchor, constant: 92),
            refreshButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 27),
            margins.trailingAnchor.constraint(equalTo: refreshButton.trailingAnchor, constant: 27),
            refreshButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? YDTableViewCell else {
            return UITableViewCell()
        }
        
        
        guard let viewModel = serviceViewModel?.cellViewModels[indexPath.row] else { return cell }
        cell.update(with: viewModel)
        
        if CoreDataManager.shared.checkIfItemExist(md5: viewModel.md5) {
                cell.savedFileImageView.image = UIImage(named: "mark.saved")
        } else {
            cell.savedFileImageView.image = UIImage(named: "mark.unsaved")
        }
        let group = DispatchGroup()
        cell.downloadButtonPressed = { [weak self] in
            if !CoreDataManager.shared.checkIfItemExist(md5: viewModel.md5) {
                self?.presentPublishedSaveFileAlert(title: viewModel.name, action1: {
                    //логика сохранения в CoreData
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
                                        self?.serviceViewModel?.saveFileToCoreData(viewModel, previewImageData)
                                        //отправляем уведомление через NotificationCenter, чтобы все контроллеры обновили закладку сохранения файла в своих таблицах
                                        NotificationCenter.default.post(name: NSNotification.Name("updateBookmarks"), object: nil)
                                        //Показать картинку закладку сохранения файла в cell.savedFileImageView
                                        cell.savedFileImageView.image = UIImage(named: "mark.saved")
                                    }
                                }
                            }
                        }
                    })
                }, action2: {
                    self?.activityIndicator.startAnimating()
                    self?.serviceViewModel?.unpublishFile(viewModel.filePath)
                })
            } else {
                self?.presentPublishedDeleteFileAlert(title: viewModel.name, action1: {
                    //логика удаления из CoreData
                    if let itemToDelete = CoreDataManager.shared.getItemFromStorageWithID(viewModel.md5) {
                        CoreDataManager.shared.deleteItem(itemToDelete)
                        NotificationCenter.default.post(name: NSNotification.Name("updateBookmarks"), object: nil)
                        cell.savedFileImageView.image = UIImage(named: "mark.unsaved")
                    }
                }, action2: {
                    self?.activityIndicator.startAnimating()
                    self?.serviceViewModel?.unpublishFile(viewModel.filePath)
                })
            }
        }
        cell.selectionStyle = .default
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceViewModel?.cellViewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        guard let isShowLoader = serviceViewModel?.isShowLoader else { return }
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex && isShowLoader && serviceViewModel?.cellViewModels.count ?? 0 >= 20 {
            tableView.showLoadingFooter()
        } else {
            tableView.hideLoadingFooter()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewModelToPass = serviceViewModel?.cellViewModels[indexPath.row] else { return }
        guard let mediaType = serviceViewModel?.cellViewModels[indexPath.row].mediaType else { return }
        
        guard let dirType = serviceViewModel?.cellViewModels[indexPath.row].directoryType else { return }
        
        serviceViewModel?.didSelectRow(with: viewModelToPass, fileType: mediaType, directoryType: dirType)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard !serviceViewModel!.isLoadingMoreData,
              !serviceViewModel!.cellViewModels.isEmpty
        else {
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight) {
                self?.serviceViewModel?.fetchAdditionalPublishedFiles()
            }
            t.invalidate()
        }
    }
    
    @objc func didPullToRefresh() {
        serviceViewModel?.reFetchData()
    }
    
    
    deinit {
        print("deinit from PublishedFilesViewController")
    }
}

