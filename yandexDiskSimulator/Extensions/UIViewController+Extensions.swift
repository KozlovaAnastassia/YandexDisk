//
//  UIViewController+Extensions.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 15.09.2023.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentUnknownFileAlert(title: String = Constants.Text.notSupportedFormat, message: String? = Constants.Text.workOnSubject, buttonTitle: String = "OK", action: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.Text.cancel, style: .cancel))
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { _ in
            action()
        }))
        present(alertController, animated: true)
    }
    
    func presentRenameAlert(title: String = Constants.Text.renameFile, message: String? = Constants.Text.enterName, buttonTitle: String = Constants.Text.doneButtonTitle, name: String, action: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { textfield in
            textfield.text = name
        }
        alertController.addAction(UIAlertAction(title: Constants.Text.cancel, style: .cancel))
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { _ in
            if let newName = alertController.textFields?[0].text {
                action(newName)
            }
            
        }))
        present(alertController, animated: true)
    }
    
    func presentDeleteAlert(title: String = Constants.Text.deleteTitle, message: String? = nil, buttonTitle: String = Constants.Text.deleteButton, action: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.Text.cancel, style: .cancel))
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .destructive, handler: { _ in
            action()
        }))
        present(alertController, animated: true)
    }
    
    func presentShareAlert(title: String = Constants.Text.shareAlertTitle, message: String? = nil, action1: @escaping () -> Void, action2: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: Constants.Text.cancel, style: .cancel))
        alertController.addAction(UIAlertAction(title: Constants.Text.shareFileButton, style: .default, handler: { _ in
            action1()
        }))
        alertController.addAction(UIAlertAction(title: Constants.Text.shareLinkButton, style: .default, handler: { _ in
            action2()
        }))
        present(alertController, animated: true)
    }
    
    func showRenamingLabel(_ renamingLabel: UILabel) {
        renamingLabel.textColor = .label
        renamingLabel.backgroundColor = .secondarySystemBackground
        renamingLabel.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        renamingLabel.clipsToBounds = true
        renamingLabel.layer.cornerRadius = 5
        renamingLabel.translatesAutoresizingMaskIntoConstraints = false
        renamingLabel.textAlignment = .center
        renamingLabel.text = Constants.Text.renamingLabelText
        view.addSubview(renamingLabel)
        NSLayoutConstraint.activate([
            renamingLabel.widthAnchor.constraint(equalToConstant: view.bounds.size.width - 130),
            renamingLabel.heightAnchor.constraint(equalToConstant: 35),
            renamingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            renamingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func removeRenamingLabel(_ renamingLabel: UILabel) {
        DispatchQueue.main.async {
            renamingLabel.translatesAutoresizingMaskIntoConstraints = false
            renamingLabel.removeFromSuperview()
        }
    }
    
    func showDeleteLabel(_ deleteLabel: UILabel) {
        deleteLabel.textColor = .label
        deleteLabel.backgroundColor = .secondarySystemBackground
        deleteLabel.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        deleteLabel.clipsToBounds = true
        deleteLabel.layer.cornerRadius = 5
        deleteLabel.translatesAutoresizingMaskIntoConstraints = false
        deleteLabel.textAlignment = .center
        deleteLabel.text = Constants.Text.deleteLabelText
        view.addSubview(deleteLabel)
        NSLayoutConstraint.activate([
            deleteLabel.widthAnchor.constraint(equalToConstant: view.bounds.size.width - 130),
            deleteLabel.heightAnchor.constraint(equalToConstant: 35),
            deleteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    func removeDeleteLabel(_ deleteLabel: UILabel) {
        DispatchQueue.main.async {
            deleteLabel.translatesAutoresizingMaskIntoConstraints = false
            deleteLabel.removeFromSuperview()
        }
    }
    
    func showSaveLabel(_ saveLabel: UILabel) {
        saveLabel.textColor = .label
        saveLabel.backgroundColor = .secondarySystemBackground
        saveLabel.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        saveLabel.clipsToBounds = true
        saveLabel.layer.cornerRadius = 5
        saveLabel.translatesAutoresizingMaskIntoConstraints = false
        saveLabel.textAlignment = .center
        saveLabel.text = Constants.Text.savingLabelText
        view.addSubview(saveLabel)
        NSLayoutConstraint.activate([
            saveLabel.widthAnchor.constraint(equalToConstant: view.bounds.size.width - 130),
            saveLabel.heightAnchor.constraint(equalToConstant: 35),
            saveLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func removeSaveLabel(_ saveLabel: UILabel) {
        DispatchQueue.main.async {
            saveLabel.translatesAutoresizingMaskIntoConstraints = false
            saveLabel.removeFromSuperview()
        }
    }
    
    func showNoConnectionLabel(_ label: UILabel) {
        label.textColor = .label
        label.numberOfLines = 2
        label.backgroundColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.clipsToBounds = true
        label.layer.cornerRadius = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = Constants.Text.noConnectionLabelText
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalTo: view.widthAnchor),
            label.heightAnchor.constraint(equalToConstant: 40),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func removeNoConnectionLabel(_ label: UILabel) {
        DispatchQueue.main.async {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.removeFromSuperview()
        }
    }
    
    
    func showNoFilesLabel() {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 3
        label.backgroundColor = .systemBackground
        label.font = UIFont.systemFont(ofSize: 36, weight: .regular)
        label.clipsToBounds = true
        label.layer.cornerRadius = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = Constants.Text.noFilesInFolder
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalTo: view.widthAnchor),
            label.heightAnchor.constraint(equalToConstant: 300),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    //    MARK: - Log out Alerts
    
    func presentLogoutAlert(title: String = Constants.Text.profileScreenTitle, message: String? = nil, action: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: Constants.Text.cancel, style: .cancel))
        alertController.addAction(UIAlertAction(title: Constants.Text.profileLogoutButton, style: .destructive, handler: { _ in
            action()
        }))
        present(alertController, animated: true)
    }
    
    func presentConfirmLogoutAlert(title: String = Constants.Text.profileLogoutButton, message: String = Constants.Text.confirmLogOutTitle, buttonTitle: String = Constants.Text.yes, action: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.Text.no, style: .cancel))
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .destructive, handler: { _ in
            action()
        }))
        present(alertController, animated: true)
    }
    
    //    MARK: - Tableview Cell File actions alert
    
    func presentPublishedSaveFileAlert(title: String, message: String? = nil, action1: @escaping () -> Void, action2: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: Constants.Text.cancel, style: .cancel))
        alertController.addAction(UIAlertAction(title: Constants.Text.saveToDevice, style: .default, handler: { _ in
            action1()
        }))
        alertController.addAction(UIAlertAction(title: Constants.Text.unpublish, style: .destructive, handler: { _ in
            action2()
        }))
        present(alertController, animated: true)
    }
    
    func presentPublishedDeleteFileAlert(title: String, message: String? = nil, action1: @escaping () -> Void, action2: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: Constants.Text.cancel, style: .cancel))
        alertController.addAction(UIAlertAction(title: Constants.Text.removeFromDevice, style: .default, handler: { _ in
            action1()
        }))
        alertController.addAction(UIAlertAction(title: Constants.Text.unpublish, style: .destructive, handler: { _ in
            action2()
        }))
        present(alertController, animated: true)
    }
    
    func presentLastUploadedSaveFileAlert(title: String, message: String? = nil, action: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: Constants.Text.cancel, style: .cancel))
        alertController.addAction(UIAlertAction(title: Constants.Text.saveToDevice, style: .default, handler: { _ in
            action()
        }))
        present(alertController, animated: true)
    }
    
    func presentLastUploadedDeleteFileAlert(title: String, message: String? = nil, action: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: Constants.Text.cancel, style: .cancel))
        alertController.addAction(UIAlertAction(title: Constants.Text.removeFromDevice, style: .default, handler: { _ in
            action()
        }))
        present(alertController, animated: true)
    }
    
    //MARK: - OFFLINE ALERT
    func presentOfflineAlert(title: String = Constants.Text.noConnectionLabelText) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alertController, animated: true)
    }
}

