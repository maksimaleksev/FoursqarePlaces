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
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
               }

    }
    override func viewDidLayoutSubviews() {
        saveButton.layer.cornerRadius = 5
    }
    
    //MARK: - @IBActions
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        guard let row = viewModel.selectedRow,
              let venueType = VenueType.convertToVenueType(viewModel.venuesType.value[row])
        else { return }
        
        print (venueType)
    }
    
    //MARK: - Methods
    
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
    }
}

