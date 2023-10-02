//
//  PublishedFilesViewModel.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import Foundation

final class PublishedFilesViewModel {
    
    var coordinator: UserProfileCoordinator?
    
    var isLoadingMoreData = false
    
    var isShowLoader = true
    
    var onUpdate: () -> Void = {}
    
    var refreshTableView: () -> Void = {}
    
    var cellViewModels: [TableViewCellViewModel] = []
    
    var savedInCoreDataFiles: [YandexDiskItem] = []
    
    private var offset = 0
    private let limit = 20
    
    private(set) var files: [YDResource] = [] {
        didSet {
            for file in files where !cellViewModels.contains(where: { $0.name == file.name }) {
                let viewModel = TableViewCellViewModel(name: file.name, date: file.created, size: file.size ?? 0, preview: file.preview ?? "" , filePath: file.path , mediaType: file.mimeType ?? "", directoryType: file.type, md5: file.md5 ?? "")
                cellViewModels.append(viewModel)
            }
        }
    }
    
    
    func fetchPublishedFiles() {
        let request = YDRequest.getPublicFilesRequest
        
        YDService.shared.execute(request, expecting: YDGetPublicResourcesListResponse.self) { result in
            switch result {
            case .success(let recievedItems):
                self.files = recievedItems.items
                self.onUpdate()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    public func fetchAdditionalPublishedFiles() {
        guard !isLoadingMoreData else {
            return
        }
        isLoadingMoreData = true
        print("Fetching more files")
        offset += 20
        print(offset)
        //create additional request
        let newRequest = YDRequest(endpoint: .publicFiles, httpMethod: "GET", pathComponents: [], queryParameters: [
            URLQueryItem(name: "path", value: "/"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)")
        ])
        
        YDService.shared.execute(newRequest, expecting: YDGetPublicResourcesListResponse.self) { result in
            switch result {
            case .success(let moreResult):
                let additionalItems = moreResult.items
                
                if additionalItems.count < self.limit {
                    self.isShowLoader = false
                }
                
                self.files.append(contentsOf: additionalItems)
                DispatchQueue.main.async {
                    self.onUpdate()
                    //в блоке success меняем флаг на false
                    self.isLoadingMoreData = false
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    func didSelectRow(with viewModel: TableViewCellViewModel, fileType: String, directoryType: String) {
        switch (fileType.lowercased(), directoryType) {
        case _ where fileType.localizedStandardContains("image"):
            coordinator?.showImageDetailViewController(with: viewModel)
        case _ where fileType.localizedStandardContains("xml"):
            coordinator?.showWebViewDetailViewController(with: viewModel)
        case _ where fileType.localizedStandardContains("pdf"):
            coordinator?.showPDFViewDetailViewController(with: viewModel)
        case _ where directoryType.localizedStandardContains("dir"):
            coordinator?.showDirectoryViewController(with: viewModel)
        default: coordinator?.showUnknowDetailViewController(with: viewModel)
        }
    }
    
    
    func reFetchData() {
        fetchPublishedFiles()
        refreshTableView()
    }
    
    //MARK: Folder ViewController methods:
    
    func fetchDirectoryFiles(_ pathForFetchingData: String) {
        //pass here directory path
        
        let request = YDRequest(endpoint: .resourcesOnly, httpMethod: "GET", pathComponents: [], queryParameters: [URLQueryItem(name: "path", value: "\(pathForFetchingData)")])
        
        YDService.shared.execute(request, expecting: YDResource.self) { result in
            switch result {
            case .success(let recievedItems):
                self.files = recievedItems.embedded?.items ?? []
                self.onUpdate()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchAdditionalDirectoryFiles(_ pathForFetchingData: String) {
        guard !isLoadingMoreData else {
            return
        }
        isLoadingMoreData = true
        
        offset += 20
        print(offset)
        //create additional request
        let newRequest = YDRequest(endpoint: .resourcesOnly, httpMethod: "GET", pathComponents: [], queryParameters: [
            URLQueryItem(name: "path", value: "\(pathForFetchingData)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)")
        ])
        
        YDService.shared.execute(newRequest, expecting: YDResource.self) { result in
            switch result {
            case .success(let moreResult):
                let additionalItems = moreResult.embedded?.items ?? []
                
                if additionalItems.count < self.limit {
                    self.isShowLoader = false
                }
                
                self.files.append(contentsOf: additionalItems)
                DispatchQueue.main.async {
                    self.onUpdate()
                    //в блоке success меняем флаг на false
                    self.isLoadingMoreData = false
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func reFetchDirectoryData(_ pathForFetchingData: String) {
        fetchDirectoryFiles(pathForFetchingData)
        refreshTableView()
    }
    
    func didSelectRowAtDirectoryViewController(with viewModel: TableViewCellViewModel, fileType: String, directoryType: String) {
        switch (fileType.lowercased(), directoryType) {
        case _ where fileType.localizedStandardContains("image"):
            coordinator?.showImageDetailViewController(with: viewModel)
        case _ where fileType.localizedStandardContains("xml"):
            coordinator?.showWebViewDetailViewController(with: viewModel)
        case _ where fileType.localizedStandardContains("pdf"):
            coordinator?.showPDFViewDetailViewController(with: viewModel)
        case _ where directoryType.localizedStandardContains("dir"):
            coordinator?.showDirectoryViewController(with: viewModel)
        default: coordinator?.showUnknowDetailViewController(with: viewModel)
        }
    }
    
//    MARK: Unpublish selected file
    
    func unpublishFile(_ path: String) {
        print("unpublish file tapped")
        let request = YDRequest(endpoint: .unpublish, httpMethod: "PUT", pathComponents: [], queryParameters: [URLQueryItem(name: "path", value: "\(path)")])
        YDService.shared.execute(request, expecting: YDFileLinkResponse.self) { result in
            switch result {
            case .success(_):
                NotificationCenter.default.post(name: NSNotification.Name("filesDidChange"), object: nil)
                self.onUpdate()
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    //    MARK: - Core Data Methods
        
        func fetchFilesFromCoreData() {
            // заполнять массив savedInCoreDataFiles при отключении интернета за счет "притаскивания" данных из CoreData
                savedInCoreDataFiles = CoreDataManager.shared.fetchSavedFiles()
        }
        
        func saveFileToCoreData(_ viewModelToSave: TableViewCellViewModel,_ imageData: Data?) {
            // сохранить переданную ВьюМодель в виде объекта CoreData
            CoreDataManager.shared.saveYandexDiskItem(viewModelToSave, imageData)

        }
    
    
    deinit {
        print("Deinit from PublishedFilesViewModel")
    }
    
}
