//
//  UserProfileViewModel.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import Foundation
import Charts

final class UserProfileViewModel: ChartViewDelegate {
    
    var coordinator: UserProfileCoordinator?
    
    var onUpdate: () -> Void = {}
    
    var occupiedData: Double = 0
    var freeSpace: Double = 0
    var totalData: Double = 0
    
    var entries = [ChartDataEntry]()
    
    var didSendEventClosure: ((UserProfileViewModel.Event) -> Void) = {_ in }
    
    enum Event {
        case closeMainTabFlow
    }
    
    func fetchDiskData() {
        let request = YDRequest.getDiskDataRequest
        YDService.shared.execute(request, expecting: YDGetDiskDataResponse.self) { result in
            switch result {
            case .success(let diskDataResponse):
                self.occupiedData = self.bytesToMegabytes(diskDataResponse.usedSpace)
                self.totalData = self.bytesToMegabytes(diskDataResponse.totalSpace)
                self.freeSpace = self.totalData - self.occupiedData
                self.onUpdate()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - Navigation:
    
    func openPublishedFiles() {
        coordinator?.showPublishedFiles()
    }
    
    func logoutUserProfile() {
        //очистить .cachesDirectory
        FileManager.removeAllFilesDirectory()
        // удалить токен из Keychain
        KeychainManager.shared.delete()
        //удалить файлы из CoreData
        CoreDataManager.shared.deleteAllFilesFromCoreData()
        //переходим на экран с кнопкой "Войти"
        didSendEventClosure(.closeMainTabFlow)
    }
    
    //MARK: - Helper methods
    
    func bytesToMegabytes(_ bytes: Int) -> Double {
        let megabytes = Double(bytes) / 1048576
        let roundedMegabytes = Double(round(100 * megabytes) / 100)
        return roundedMegabytes
    }
    deinit {
        print("deinit from UserProfileViewModel")
    }
}
