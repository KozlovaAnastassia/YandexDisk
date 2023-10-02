//
//  Constants.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 02.10.2023.
//

import Foundation


enum Constants {
    
    enum Text {
        //MARK: - Login View
        static let loginViewButton = Bundle.main.localizedString(forKey: "LoginView.loginButtonTitle", value: "Войти", table: "Localizable")
        static let skillboxDrive = Bundle.main.localizedString(forKey: "SkillboxDrive", value: "Skillbox Диск", table: "Localizable")
        
        //MARK: - DemoViewController
         static let demoNextButton = Bundle.main.localizedString(forKey: "DemoViewController.nextButton", value: "Далее", table: "Localizable")
        static let skipButton = Bundle.main.localizedString(forKey: "DemoViewController.skipButton", value: "Пропустить", table: "Localizable")
        static let page1TitleText = Bundle.main.localizedString(forKey: "page1TitleText", value: "Теперь ваши документы в одном месте", table: "Localizable")
        static let page2TitleText = Bundle.main.localizedString(forKey: "page2TitleText", value: "Доступ к файлам без интернета", table: "Localizable")
        static let page3TitleText = Bundle.main.localizedString(forKey: "page3TitleText", value: "Делитесь вашими файлами с другими", table: "Localizable")
        
        //MARK: - TabCoordinator
        static let pageTitleProfile = Bundle.main.localizedString(forKey: "pageTitle.profile", value: "Профиль", table: "Localizable")
        static let pageTitleLastUploaded = Bundle.main.localizedString(forKey: "pageTitle.lastUploaded", value: "Последние", table: "Localizable")
        static let pageTitleAllFiles = Bundle.main.localizedString(forKey: "pageTitle.allFiles", value: "Все файлы", table: "Localizable")
        
        
        //MARK: - UserProfileViewController
        static let profilePublishedButtonTitle = Bundle.main.localizedString(forKey: "userProfile.publishedButtonTitle", value: "Опубликованные файлы", table: "Localizable")
        static let profileScreenTitle = Bundle.main.localizedString(forKey: "userProfile.screenTitle", value: "Профиль", table: "Localizable")
        static let profileOccupied = Bundle.main.localizedString(forKey: "userProfile.occupied", value: "Занято", table: "Localizable")
        static let profileAvailable = Bundle.main.localizedString(forKey: "userProfile.available", value: "Доступно", table: "Localizable")
        static let profileAbbreviationGB = Bundle.main.localizedString(forKey: "userProfile.abbreviationGB", value: "ГБ", table: "Localizable")
        static let profilePieChartLabel = Bundle.main.localizedString(forKey: "userProfile.gigabyte", value: "Гигабайт", table: "Localizable")
        static let profileLogoutButton = Bundle.main.localizedString(forKey: "userProfile.logoutButton", value: "Выйти", table: "Localizable")
        
        //MARK: - LastUploadedViewController
        static let lastUploadedScreenTitle = Bundle.main.localizedString(forKey: "lastUploaded.screenTitle", value: "Последние", table: "Localizable")
        
        //MARK: - AllFilesViewController
        static let allFilesScreenTitle = Bundle.main.localizedString(forKey: "allFiles.screenTitle", value: "Все файлы", table: "Localizable")
        
        //MARK: - extension UIViewController
        static let notSupportedFormat = Bundle.main.localizedString(forKey: "ViewControllerExtension.notSupportedFormat", value: "К сожалению данный формат пока не поддерживается", table: "Localizable")
        static let workOnSubject = Bundle.main.localizedString(forKey: "ViewControllerExtension.workOnSubject", value: "Мы работаем над этим", table: "Localizable")
        static let cancel = Bundle.main.localizedString(forKey: "ViewControllerExtension.cancel", value: "Отмена", table: "Localizable")
        static let renameFile = Bundle.main.localizedString(forKey: "ViewControllerExtension.renameFile", value: "Переименовать", table: "Localizable")
        static let enterName = Bundle.main.localizedString(forKey: "ViewControllerExtension.enterName", value: "Введите новое имя файла", table: "Localizable")
        static let doneButtonTitle = Bundle.main.localizedString(forKey: "ViewControllerExtension.done", value: "Готово", table: "Localizable")
        static let deleteTitle = Bundle.main.localizedString(forKey: "ViewControllerExtension.deleteTitle", value: "Удалить объект?", table: "Localizable")
        static let deleteButton = Bundle.main.localizedString(forKey: "ViewControllerExtension.deleteButton", value: "Удалить", table: "Localizable")
        static let shareAlertTitle = Bundle.main.localizedString(forKey: "ViewControllerExtension.shareAlertTitle", value: "Поделиться", table: "Localizable")
        static let shareFileButton = Bundle.main.localizedString(forKey: "ViewControllerExtension.shareFileButton", value: "Файлом", table: "Localizable")
        static let shareLinkButton = Bundle.main.localizedString(forKey: "ViewControllerExtension.shareLinkButton", value: "Ссылкой", table: "Localizable")
        static let renamingLabelText = Bundle.main.localizedString(forKey: "ViewControllerExtension.renamingLabelText", value: "Переименовывается...", table: "Localizable")
        static let deleteLabelText = Bundle.main.localizedString(forKey: "ViewControllerExtension.deleteLabelText", value: "Удаляется...", table: "Localizable")
        static let savingLabelText = Bundle.main.localizedString(forKey: "ViewControllerExtension.savingLabelText", value: "Сохраняется...", table: "Localizable")
        static let noConnectionLabelText = Bundle.main.localizedString(forKey: "ViewControllerExtension.noConnectionLabelText", value: "Отсутствует подключение к интернету", table: "Localizable")
        static let noFilesInFolder = Bundle.main.localizedString(forKey: "ViewControllerExtension.noFilesInFolder", value: "Директория не содержит файлов", table: "Localizable")
//        static let signOffTitle = Bundle.main.localizedString(forKey: "ViewControllerExtension.signOffTitle", value: "Выход", table: "Localizable")
        static let confirmLogOutTitle = Bundle.main.localizedString(forKey: "ViewControllerExtension.confirmLogOutTitle", value: "Вы уверены, что хотите выйти?", table: "Localizable")
        static let yes = Bundle.main.localizedString(forKey: "ViewControllerExtension.yes", value: "Да", table: "Localizable")
        static let no = Bundle.main.localizedString(forKey: "ViewControllerExtension.no", value: "Нет", table: "Localizable")
        static let saveToDevice = Bundle.main.localizedString(forKey: "ViewControllerExtension.saveToDevice", value: "Сохранить в избранное", table: "Localizable")
        static let removeFromDevice = Bundle.main.localizedString(forKey: "ViewControllerExtension.deleteFromDevice", value: "Удалить из избранного", table: "Localizable")
        static let unpublish = Bundle.main.localizedString(forKey: "ViewControllerExtension.unpublish", value: "Убрать публикацию", table: "Localizable")
        
        //MARK: - PublishedFilesViewController
        static let reload = Bundle.main.localizedString(forKey: "ViewControllerExtension.reload", value: "Обновить", table: "Localizable")
        static let publishedFiles = Bundle.main.localizedString(forKey: "ViewControllerExtension.publishedFiles", value: "Опубликованные файлы", table: "Localizable")
        static let haveNopublishedFiles = Bundle.main.localizedString(forKey: "ViewControllerExtension.haveNopublishedFiles", value: "У вас пока нет опубликованных файлов", table: "Localizable")

    }
}
