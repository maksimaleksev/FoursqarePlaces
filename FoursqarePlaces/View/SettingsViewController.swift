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
    
    //MARK: - Variables
    
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
        self.tabBarController?.selectedIndex = 0
    }
    
    //MARK: - Methods
    
    private func setupViewController() {
    }
}


//MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.componentsNumber
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.venuesType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.venuesType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(viewModel.venuesType[row])
    }
    
}
