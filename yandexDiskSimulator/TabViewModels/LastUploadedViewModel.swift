//
//  LastUploadedViewModel.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 15.09.2023.
//

import Foundation

final class LastUploadedViewModel {
    
    var coordinator: LastUploadedCoordinator?
    
    var isLoadingMoreData = false
    
    var onUpdate: () -> Void = {}
    
    var refreshTableView: () -> Void = {}
    
    var cellViewModels: [TableViewCellViewModel] = []
    
    var savedInCoreDataFiles: [YandexDiskItem] = []
    
    let request = YDRequest.lastUploadedRequest
    
    private(set) var files: [YDResource] = [] {
        didSet {
            for file in files where !cellViewModels.contains(where: { $0.name == file.name }) {
                let viewModel = TableViewCellViewModel(name: file.name , date: file.created , size: file.size ?? 0, preview: file.preview ?? "", filePath: file.path , mediaType: file.mimeType ?? "", directoryType: "", md5: file.md5 ?? "")
                cellViewModels.append(viewModel)
            }
        }
    }
    
    public func fetchFiles() {
        let request = YDRequest.lastUploadedRequest
        
        YDService.shared.execute(request, expecting: YDGetLastUploadedResponse.self) { result in
            switch result {
            case .success(let recievedItems):
                self.files = recievedItems.items
                self.onUpdate()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func fetchAdditionalFiles() {
        guard !isLoadingMoreData else {
            return
        }
        isLoadingMoreData = true
        print("Fetching more files")
        //create additional request
        //NB! API Яндекс диска не поддерживает пагинацию при запросе последних добавленных файлов
        //в блоке success меняем флаг на false
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.isLoadingMoreData = false
        }
    }
    
    func didSelectRow(with viewModel: TableViewCellViewModel, fileType: String) {
        switch fileType.lowercased() {
        case _ where fileType.localizedStandardContains("image"):
            coordinator?.showImageDetailViewController(with: viewModel)
        case _ where fileType.localizedStandardContains("xml"):
            coordinator?.showWebViewDetailViewController(with: viewModel)
        case _ where fileType.localizedStandardContains("pdf"):
            coordinator?.showPDFViewDetailViewController(with: viewModel)
        default: coordinator?.showUnknowDetailViewController(with: viewModel)
        }
    }
    
    func didSelectRowOffline(with viewModel: YandexDiskItem, fileType: String) {
        switch fileType.lowercased() {
        case _ where fileType.localizedStandardContains("image"):
            coordinator?.offlineShowImageDetailViewController(with: viewModel)
        case _ where fileType.localizedStandardContains("xml"):
            coordinator?.offlineShowWebViewDetailViewController(with: viewModel)
        case _ where fileType.localizedStandardContains("pdf"):
            coordinator?.offlineShowPDFViewDetailViewController(with: viewModel)
        default: coordinator?.offlineShowUnknowDetailViewController(with: viewModel)
        }
    }
    
    func reFetchData() {
        fetchFiles()
        refreshTableView()
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
        print("Deinit from LastUploadedViewModel")
    }
    
}
