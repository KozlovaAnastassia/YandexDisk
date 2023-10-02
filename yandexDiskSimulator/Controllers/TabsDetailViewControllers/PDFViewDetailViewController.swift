//
//  PDFViewDetailViewController.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 16.09.2023.
//

import UIKit
import PDFKit
import Network

class PDFViewDetailViewController: UIViewController {
    
    var viewModel: DetailViewControllerViewModel?
    
    var networkCheck = NetworkCheck.sharedInstance()
    
    private let activityIndicator = UIActivityIndicatorView()
    let pdfView = PDFView()
    var resourceUrl: URL?
    private let `label` = UILabel()
    var items = [UIBarButtonItem]()
    
    override func viewDidLoad() {
        
        viewModel?.onDeleteUpdate = { [weak self] deleteResponse in
            NotificationCenter.default.post(name: NSNotification.Name("filesDidChange"), object: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.dismiss(animated: true)
                guard let label = self?.label else { return }
                self?.removeDeleteLabel(label)
            }
        }
        
        viewModel?.onRenameUpdate = { [weak self] renameResponse in
            NotificationCenter.default.post(name: NSNotification.Name("filesDidChange"), object: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.dismiss(animated: true)
                guard let label = self?.label else { return }
                self?.removeRenamingLabel(label)
            }
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(renameTapped))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward"), style: .plain, target: self, action: #selector(backTapped))
        
        let shareToolBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareTapped))
        items.append(shareToolBarButton)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        items.append(spacer)
        
        let deleteToolBarButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteTapped))
        items.append(deleteToolBarButton)
        
        toolbarItems = items
        
        navigationController?.setToolbarHidden(false, animated: false)
        
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItems = [ UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(renameTapped)),
        ]
        
        activityIndicator.startAnimating()
        setupViews()
        setupHierarchy()
        setupLayout()
        
        if networkCheck.currentStatus == .satisfied {
            viewModel?.downloadFile(completion: { downloadResponse in
                //load image from local storage
                let localCacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                let localFileURL = localCacheURL.appendingPathComponent(self.viewModel?.cellViewModel?.md5 ?? "")
                let path = localFileURL.path
                //если по указанному пути есть файл, то грузим оттуда картинку (открытие происходит быстро, так как предварительно файл с уникальным идентификатором был сохранен в кеш)
                if FileManager.default.fileExists(atPath: path) {
                    self.resourceUrl = URL(string: localFileURL.absoluteString)
                    self.displayPdf()
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                } else {
                    self.resourceUrl = URL(string: downloadResponse.href)
                    self.displayPdf()
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                }
            })
        } else {
            self.displayPdf()
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
        
        
        
    }
    
    private func displayPdf() {
        DispatchQueue.main.async {
            if let pdfDocument = self.createPdfDocument() {
                self.pdfView.document = pdfDocument
            }
        }
    }
    
    private func createPdfDocument() -> PDFDocument? {
        if networkCheck.currentStatus == .satisfied {
            if let url = resourceUrl  {
                return PDFDocument(url: url)
            }
        } else {
            if let data = viewModel?.offlineModel?.fileData {
                return PDFDocument(data: data)
            }
        }
        return nil
    }
    
    
    private func setupViews() {
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.autoScales = true
        if let titleString = viewModel?.cellViewModel?.name, let subtitleString = viewModel?.cellViewModel?.date
        {
            let resultSubtitle = viewModel?.prepareSubtitle(subtitle: subtitleString) ?? "unknown date and time"
            navigationItem.setTitle(title: titleString, subtitle: resultSubtitle)
        }
        view.backgroundColor = .systemBackground
        activityIndicator.color = .darkGray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func setupHierarchy() {
        view.addSubviews(pdfView, activityIndicator)
    }
    
    private func setupLayout() {
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pdfView.topAnchor.constraint(equalTo: margins.topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: margins.centerYAnchor)
        ])
    }
    
    @objc private func backTapped() {
        dismiss(animated: true)
    }
    
    @objc private func renameTapped() {
        if networkCheck.currentStatus == .satisfied {
            guard let name = viewModel?.cellViewModel?.name else { return }
            self.presentRenameAlert(name: name) { [weak self] newName in
                guard let label = self?.label else { return }
                self?.viewModel?.renameFile(newName)
                self?.showRenamingLabel(label)
            }
        } else {
            self.presentOfflineAlert()
        }
    }
    
    @objc private func shareTapped() {
        if networkCheck.currentStatus == .satisfied {
            self.presentShareAlert { [weak self] in
                let fileName = self?.viewModel?.cellViewModel?.name as Any
                if let pdfData = self?.pdfView.document?.dataRepresentation() {
                    let vc = UIActivityViewController(activityItems: [pdfData, fileName], applicationActivities: [])
                    DispatchQueue.main.async {
                        vc.popoverPresentationController?.barButtonItem = self?.navigationItem.rightBarButtonItem
                        self?.present(vc, animated: true)
                    }
                }
            } action2: { [weak self] in
                self?.viewModel?.shareReferenceToFile()
                self?.viewModel?.shareFileURL = { [weak self] publicURLstring in
                    let url = URL(string: publicURLstring) as Any
                    let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
                    DispatchQueue.main.async {
                        vc.popoverPresentationController?.barButtonItem = self?.navigationItem.rightBarButtonItem
                        self?.present(vc, animated: true)
                    }
                }
            }
        } else {
            self.presentOfflineAlert()
        }
    }
    
    @objc private func deleteTapped() {
        if networkCheck.currentStatus == .satisfied {
            self.presentDeleteAlert { [weak self] in
                self?.viewModel?.deleteFile()
                guard let label = self?.label else { return }
                self?.showDeleteLabel(label)
            }
        } else {
            self.presentOfflineAlert()
        }
    }
    
    
    
    deinit {
        print("deinit from PDFViewDetailViewController")
    }
}
