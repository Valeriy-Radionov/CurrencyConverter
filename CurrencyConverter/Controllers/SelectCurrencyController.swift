//
//  SelectCurrencyController.swift
//  CurrencyConverter
//
//  Created by Valera on 26.02.22.
//

import UIKit

enum FlagCurrencySelected {
    case from
    case to
}
class SelectCurrencyController: UITableViewController {
    
    var flagCurrency: FlagCurrencySelected = .from
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func pushCancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension SelectCurrencyController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shared.currencies.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellCurrency", for: indexPath) as? SelectedCourceCell else { return UITableViewCell() }
        DispatchQueue.main.async {
            let currentCurrency = Model.shared.currencies[indexPath.row]
            cell.initCell(currency: currentCurrency)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCurrency: Currency = Model.shared.currencies[indexPath.row]
        
        if flagCurrency == .from {
            Model.shared.fromCurrency = selectedCurrency
        }
        
        if flagCurrency == .to {
            Model.shared.toCurrency = selectedCurrency
        }
        dismiss(animated: true, completion: nil)
    }
}
