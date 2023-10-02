//
//  DemoViewController.swift
//  yandexDiskSimulator
//
//  Created by Анастасия on 15.09.2023.
//

import UIKit

class DemoViewController: UIPageViewController {
    
    var viewModel: DemoViewModel?
    
    var pages = [UIViewController]()
    
    let nextButton: UIButton = {
        let button = UIButton (type: .system)
        button.setTitle(Constants.Text.demoNextButton, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    let pageControl = UIPageControl()
    let initialPage = 0
    
    var pageControlBottomAnchor: NSLayoutConstraint?
    var nextButtonBottomAnchor: NSLayoutConstraint?
    var skipButtonTopAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        style()
        layout()
    }
    
    deinit {
        print("DemoViewController deinit")
    }
    
}

extension DemoViewController {
    
    func setup() {
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(DemoViewController.skipTapped(_:)))
//
//        dataSource = self
//        delegate = self
//
//        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
//
//        pageControl.currentPageIndicatorTintColor = .label
//
//        let page1 = OnboardingViewController(imageName: "TwoFolders", titleText: Constants.Text.page1TitleText, subtitleText: "")
//
//        let page2 = OnboardingViewController(imageName: "CheckedFolder", titleText: Constants.Text.page2TitleText, subtitleText: "")
//
//        let page3 = OnboardingViewController(imageName: "Pencil", titleText: Constants.Text.page3TitleText, subtitleText: "")
//
//
//        pages.append(page1)
//        pages.append(page2)
//        pages.append(page3)
//
//        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
    }
    
    func style() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .systemGray2
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
        
        nextButton.addTarget(self, action: #selector(nextTapped(_:)), for: .primaryActionTriggered)
    }
    
    func layout() {
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 30),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            view.trailingAnchor.constraint(equalTo: nextButton.trailingAnchor, constant: 27),
        ])
        
        // for animations
        pageControlBottomAnchor = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 180)
        nextButtonBottomAnchor = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 92)
        
        
        pageControlBottomAnchor?.isActive = true
        skipButtonTopAnchor?.isActive = true
        nextButtonBottomAnchor?.isActive = true
    }
    
}

// MARK: - DataSource

extension DemoViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex == 0 {
            return pages.last               // wrap last
        } else {
            return pages[currentIndex - 1]  // go previous
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]  // go next
        } else {
            return pages.first              // wrap first
        }
    }
    
}

// MARK: - Delegates

extension DemoViewController: UIPageViewControllerDelegate {
    
    // How we keep our pageControl in sync with viewControllers
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
        animateControlsIfNeeded()
    }
    
    private func animateControlsIfNeeded() {
        let lastPage = pageControl.currentPage == pages.count - 1
        
        if lastPage {
            hideControls()
        } else {
            showControls()
        }
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideControls() {
        skipButtonTopAnchor?.constant = -80
    }
    
    private func showControls() {
        skipButtonTopAnchor?.constant = 16
    }
}

// MARK: - Actions

extension DemoViewController {
    
    
    @objc func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
        animateControlsIfNeeded()
    }
    
    @objc func skipTapped(_ sender: UIButton) {
        let lastPage = pages.count - 1
        pageControl.currentPage = lastPage
        
        goToSpecificPage(index: lastPage, ofViewControllers: pages)
        animateControlsIfNeeded()
    }
    
    @objc func nextTapped(_ sender: UIButton) {
        let lastPage = pages.count - 1
        if  pageControl.currentPage == lastPage {
            viewModel?.showAuthPage()
            animateControlsIfNeeded()
        } else {
            pageControl.currentPage += 1
            goToNextPage()
            animateControlsIfNeeded()
        }
    }
    
}

// MARK: - Extensions

extension UIPageViewController {
    
    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        
        setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
    }
    
    func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let prevPage = dataSource?.pageViewController(self, viewControllerBefore: currentPage) else { return }
        
        setViewControllers([prevPage], direction: .forward, animated: animated, completion: completion)
    }
    
    func goToSpecificPage(index: Int, ofViewControllers pages: [UIViewController]) {
        setViewControllers([pages[index]], direction: .forward, animated: true, completion: nil)
    }
}
