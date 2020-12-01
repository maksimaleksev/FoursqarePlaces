//
//  SettingsViewController.swift
//  FoursqarePlaces
//
//  Created by Maxim Alekseev on 29.11.2020.
//

import UIKit
import RxCocoa
import RxSwift

class SettingsViewController: UIViewController {
    
    //MARK: - Services
    let disposeBag = DisposeBag()
    
    //MARK: - View Model
    
    var viewModel = SettingsViewModel()
    
    //MARK: - @IBOutlets
    @IBOutlet weak var venueTypePickerVeiw: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        additionalViewControllerSetup()
    }
    
    override func viewDidLayoutSubviews() {
        saveButton.layer.cornerRadius = 5
    }
    
    //MARK: - @IBActions
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        let row = viewModel.selectedRow
        guard let venueType = VenueType.convertToVenueType(viewModel.venuesType.value[row]) else { return }
        viewModel.set(row: row, and: venueType)
        self.tabBarController?.selectedIndex = 0
    }
    
    //MARK: - Methods
    
    //For setup VC in viewDidLoad
    private func setupViewController() {
        //Set data for venueTypePickerVeiw
        viewModel.venuesType.bind(to: venueTypePickerVeiw.rx.itemTitles){ row, element in
            return element
        }.disposed(by: disposeBag)
        
        //Get selected item in venueTypePickerVeiw
        venueTypePickerVeiw.rx.itemSelected
            .subscribe {[unowned self] (event) in
                switch event {
                case .next(let selected):
                    self.viewModel.selectedRow = selected.row
                default:
                    break
                }
            }.disposed(by: disposeBag)
        
        //Set VC when app become active
        viewModel.didAppBecomeActive.subscribe (onNext:{ [additionalViewControllerSetup] isActive in
            
            guard isActive else { return }
            additionalViewControllerSetup()
        }).disposed(by: disposeBag)
    }
    
    //For setup VC in viewWillAppear
    private func additionalViewControllerSetup() {
        
        setBackgroundViewColor()
        venueTypePickerVeiw.selectRow(viewModel.settedRow, inComponent: 0, animated: true)
    }
    
    private func setBackgroundViewColor() {
        
        switch self.traitCollection.userInterfaceStyle {
        
        case .unspecified:
            view.backgroundColor = .white
        case .light:
            view.backgroundColor = .white
        case .dark:
            view.backgroundColor = .black
        @unknown default:
            view.backgroundColor = .white
        }
    }
}

