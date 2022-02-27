//
//  SelectedCourceCell.swift
//  CurrencyConverter
//
//  Created by Valera on 27.02.22.
//

import UIKit

class SelectedCourceCell: UITableViewCell {

    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var currencyNameLabel: UILabel!
    
    func initCell(currency: Currency) {
        flagImage.image = currency.imageFlag
        currencyNameLabel.text = currency.Name
        flagImage.layer.cornerRadius = 10
    }

}
