//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Valera on 26.02.22.
//

import Foundation
import UIKit

class Currency {
    var NumCode: String?
    var CharCode: String?
    
    var Nominal: String?
    var nominalDouble: Double?
    
    var Name: String?
    var Value: String?
    var valueDauble: Double?
    var imageFlag: UIImage? {
        if let charCode = CharCode {
            return UIImage(named: charCode+".png")
        }
        return nil
    }
    
    class func rouble() -> Currency {
        let rouble = Currency()
        rouble.CharCode = "RUR"
        rouble.Name = "Российский рубль"
        rouble.Nominal = "1"
        rouble.nominalDouble = 1
        rouble.Value = "1"
        rouble.valueDauble = 1
        return rouble
    }
}
