//
//  UserProfileViewController.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 13.09.2023.
//

import UIKit
import Charts
import Network

class UserProfileViewController: UIViewController, ChartViewDelegate, NetworkCheckObserver {

    var viewModel: UserProfileViewModel?
    
    var networkCheck = NetworkCheck.sharedInstance()
    
    let `label` = UILabel()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    let pieChart = PieChartView()
    
    let showPublishedButton = UIButton.customButton(title: Constants.Text.profilePublishedButtonTitle, backgroundColor: .systemBackground, titleColor: .label, fontSize: 18, radius: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if networkCheck.currentStatus == .satisfied {
            
            setupViews()
            setupHierarchy()
            
            activityIndicator.startAnimating()
            
            viewModel?.fetchDiskData()
            
            setupLayout()
            
            viewModel?.onUpdate = { [weak self] in
                self?.setPieChartData()
            }
            
        } else {
            self.showNoConnectionLabel(label)
            setupViews()
            setupHierarchy()
            setupLayout()
            pieChart.isHidden = true
            showPublishedButton.isHidden = true
        }
        
        networkCheck.addObserver(observer: self)
        
    }
    
    
    func statusDidChange(status: NWPath.Status) {
            if status == .satisfied {
                       //Do something
                viewModel?.fetchDiskData()
                
                viewModel?.onUpdate = { [weak self] in
                    self?.setPieChartData()
                }
                
                self.removeNoConnectionLabel(label)
                pieChart.isHidden = false
                showPublishedButton.isHidden = false
                
            } else if status == .unsatisfied {
                //Show no network alert
                self.showNoConnectionLabel(label)
                pieChart.isHidden = true
                showPublishedButton.isHidden = true
            }
        }
    
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = Constants.Text.profileScreenTitle
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        let legend = pieChart.legend
        
        legend.horizontalAlignment = .left
        legend.verticalAlignment = .bottom
        legend.orientation = .vertical
        pieChart.holeColor = .systemBackground
        activityIndicator.center = view.center
        activityIndicator.style = .large
        pieChart.delegate = viewModel
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.Text.profileLogoutButton, style: .plain, target: self, action: #selector(logoutTapped))
        
        guard let arrow = UIImage(named: "rightArrow") else { return }
        
        showPublishedButton.contentHorizontalAlignment = .left
        showPublishedButton.addRightImage(image: arrow, offset: 5)
        showPublishedButton.addTarget(self, action: #selector(openPublishedTapped), for: .touchUpInside)
        
        showPublishedButton.createDefaultShadow(for: showPublishedButton, cornerRadius: 5)
    }
    
    @objc private func logoutTapped() {
        self.presentLogoutAlert { [weak self] in
            self?.presentConfirmLogoutAlert { [weak self] in
                self?.viewModel?.logoutUserProfile()
            }
        }
    }
    
    @objc private func openPublishedTapped() {
        viewModel?.openPublishedFiles()
    }
    
    private func  setupHierarchy() {
        view.addSubviews(activityIndicator, pieChart, showPublishedButton)
    }
    
    
    
    private func setupLayout() {
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            pieChart.topAnchor.constraint(equalTo: margins.topAnchor),
            pieChart.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            pieChart.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            pieChart.heightAnchor.constraint(equalToConstant: view.bounds.size.height / 2),
            
            
            showPublishedButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            showPublishedButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            showPublishedButton.heightAnchor.constraint(equalToConstant: 40),
            showPublishedButton.topAnchor.constraint(equalTo: pieChart.bottomAnchor, constant: 50)
        ])
    }

    
    //    MARK: - Setup PieChart
        
        private func setPieChartData() {
            DispatchQueue.main.async {
                self.viewModel?.entries.removeAll()
                
                self.activityIndicator.stopAnimating()
                
                guard let occupiedEntry = self.viewModel?.occupiedData, let totalEntry = self.viewModel?.totalData, let freeSpaceEntry = self.viewModel?.freeSpace else { return }
                
                self.pieChart.drawEntryLabelsEnabled = true
                
                self.viewModel?.entries.append(
                    PieChartDataEntry(value: occupiedEntry/1000, label:  Constants.Text.profileOccupied))
                self.viewModel?.entries.append(
                    PieChartDataEntry(value: freeSpaceEntry/1000, label: Constants.Text.profileAvailable))
                
                let set = PieChartDataSet(entries: self.viewModel?.entries ?? [])
                
                set.colors = ChartColorTemplates.pastel()
                let myAttrString = NSAttributedString(string: "\(totalEntry/1000) \(Constants.Text.profileAbbreviationGB)", attributes: [
                    .font: UIFont.systemFont(ofSize: 24, weight: .regular),
                    .foregroundColor: UIColor.label
                ])
                self.pieChart.centerAttributedText = myAttrString
                
                self.pieChart.entryLabelColor = .label
                set.label = Constants.Text.profilePieChartLabel
                let data = PieChartData(dataSet: set)
                self.pieChart.data = data
            }
        }
    
    
}

