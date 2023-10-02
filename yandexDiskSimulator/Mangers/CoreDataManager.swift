//
//  CoreDataManager.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//
import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "SkillboxDrive")
        persistentContainer.loadPersistentStores { _, error in
            print(error?.localizedDescription ?? "")
        }
        return persistentContainer
    }()
    
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func getItemFromStorageWithID(_ md5: String) -> YandexDiskItem? {
        let allCoreDataItems = fetchSavedFiles()
        for item in allCoreDataItems {
            if item.md5 == md5 {
                return item
            }
        }
        return nil
    }
    
    func saveYandexDiskItem(_ viewModel: TableViewCellViewModel,_ imageData: Data?) {
        let yandexDiskItem = YandexDiskItem(context: viewContext)
        yandexDiskItem.name = viewModel.name
        yandexDiskItem.size = viewModel.sizeInMegaBytes
        yandexDiskItem.created = viewModel.formattedDate
        yandexDiskItem.image = imageData
        yandexDiskItem.md5 = viewModel.md5
        yandexDiskItem.mediaType = viewModel.mediaType
        yandexDiskItem.fileData = viewModel.fileData
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    
    func fetchSavedFiles() -> [YandexDiskItem] {
        let request: NSFetchRequest<YandexDiskItem> = YandexDiskItem.fetchRequest()
        do {
            let files = try viewContext.fetch(request)
            return files
        } catch {
            print(error)
            return []
        }
    }
    
    
    func deleteItem(_ item: YandexDiskItem) {
        viewContext.delete(item)
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    
    func deleteAllFilesFromCoreData() {
        let request: NSFetchRequest<YandexDiskItem> = YandexDiskItem.fetchRequest()
        do {
            let files = try viewContext.fetch(request)
            files.forEach { file in
                deleteItem(file)
            }
        } catch {
            print(error)
        }
    }
    
    
    func checkIfItemExist(md5: String) -> Bool {
        let request = NSFetchRequest<YandexDiskItem>(entityName: "YandexDiskItem")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "md5 == %@", md5)
        do {
            let count = try viewContext.count(for: request)
            if count > 0 {
                return true
            } else {
               return false
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
    
    
}
