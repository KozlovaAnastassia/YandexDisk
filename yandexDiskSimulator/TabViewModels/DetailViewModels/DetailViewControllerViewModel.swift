//
//  DetailViewControllerViewModel.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 15.09.2023.
//

import Foundation

final class DetailViewControllerViewModel: NSObject {
    
    weak var coordinator: Coordinator?
    
    var cellViewModel: TableViewCellViewModel?
    
    var offlineModel: YandexDiskItem?
    
    var shareFileURL: (String) -> Void = { _ in }
    
    var onRenameUpdate: (YDFileLinkResponse) -> Void = { _ in }
    
    var onDeleteUpdate: (YDFileLinkResponse) -> Void = { _ in }
    
    public func downloadFile(completion: @escaping (YDFileLinkResponse)->Void) {
        let request = YDRequest(endpoint: .download, httpMethod: "GET", pathComponents: [], queryParameters: [URLQueryItem(name: "path", value: "\(cellViewModel?.filePath ?? "")")])
        
        YDService.shared.execute(request, expecting: YDFileLinkResponse.self) { result in
            switch result {
            case .success(let downloadResponse):
                completion(downloadResponse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func prepareSubtitle(subtitle: String) -> String {
        let date = Date.createDateFromString(dateString: subtitle)
        let stringFromDate = Date.createStringFromDate(date: date)
        return stringFromDate
    }
    
    //MARK: Rename file
    
    func renameFile(_ newName: String) {
        guard let previousFileName = cellViewModel?.name else { return }
        guard let previousFilePath = cellViewModel?.filePath else { return }
        let newFilePath = previousFilePath.replacingOccurrences(of: previousFileName, with: newName)
        
        let request = YDRequest(endpoint: .move, httpMethod: "POST", pathComponents: [], queryParameters: [
            URLQueryItem(name: "from", value: "\(cellViewModel?.filePath ?? "")"),
            URLQueryItem(name: "path", value: "\(newFilePath)")
        ])
        
        YDService.shared.execute(request, expecting: YDFileLinkResponse.self) { result in
            switch result {
            case .success(let renameResponse):
                self.onRenameUpdate(renameResponse)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    //MARK: Get file's meta data
    
    func getFileMetaData(_ urlString: String, completion: @escaping (YDResource)->Void) {
       let token = KeychainManager.shared.getTokenFromKeychain()
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("OAuth \(token ?? "")", forHTTPHeaderField: "Authorization")
        YDService.shared.getData(request, expecting: YDResource.self) { result in
            switch result {
            case .success(let fileMetaDataResponse):
                completion(fileMetaDataResponse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    //MARK: Share file
    
    func shareFile() {
        print("share file")
    }
    
    func shareReferenceToFile() {
        print("share reference to file")
        //отправим с помощью APIService запрос publish
        guard let filePath = cellViewModel?.filePath else { return }
        let request = YDRequest(endpoint: .publish, httpMethod: "PUT", pathComponents: [], queryParameters: [URLQueryItem(name: "path", value: "\(filePath)")])
        YDService.shared.execute(request, expecting: YDFileLinkResponse.self) { result in
            switch result {
            case .success(let success):
                //по ссылке из успешного ответа отправляем запрос на получение метаданных файла, а именно public_url - пользователи, которым владелец ресурса передаст эту ссылку, смогут открыть опубликованную папку или скачать файл.
                self.getFileMetaData(success.href) { fileMetaData in
                    //передаем эту ссылку (string) в комплишн
                    guard let urlString = fileMetaData.publicURL else { return }
                    //отправляем уведомление, чтобы автоматически обновился список в контроллере опубликованных файлов
                    NotificationCenter.default.post(name: NSNotification.Name("filesDidChange"), object: nil)
                    self.shareFileURL(urlString)
                    //в контроллере реализуем комплишн, презентуя UIActivityViewController
                }
            case .failure(_):
                print("Failed to get Link object")
            }
        }
        
    }
    
    //MARK: Delete file
    
    //  тело ответа мы получаем только для непустой папки - если просиходит удаление файла или пустой папки, то API отвечает кодом 204 No content (ресурс успешно удален) без тела ответа.
    
    func deleteFile() {
        guard let filePath = cellViewModel?.filePath else { return }
        let request = YDRequest(endpoint: .resourcesOnly, httpMethod: "DELETE", pathComponents: [], queryParameters: [URLQueryItem(name: "path", value: "\(filePath)")])
        YDService.shared.deleteFile(request, expecting: YDFileLinkResponse.self) { result in
            switch result {
            case .success(let success):
                self.onDeleteUpdate(success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    deinit {
        print("deinit from LastUploadedDetailViewModel")
    }
}


