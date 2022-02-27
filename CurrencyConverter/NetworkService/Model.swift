//
//  Model.swift
//  CurrencyConverter
//
//  Created by Valera on 25.02.22.
//

import UIKit

class Model: NSObject {
    
    static let shared = Model()
    
    var currencies: [Currency] = []
    var currentCurrency: Currency?
    var fromCurrency: Currency = Currency.rouble()
    var toCurrency: Currency = Currency.rouble()
    var currentCharacters: String = ""
    var currentDate: String = ""
    var pathForXML: String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]+"/data.xml"
        
        if FileManager.default.fileExists(atPath: path) {
            return path
        }
        return Bundle.main.path(forResource: "data", ofType: "xml")!
    }
    
    var urlForXML: URL? {
        return URL(fileURLWithPath: pathForXML)
    }
    
    func convert(amount: Double?) -> String {
        if amount == nil {
            return ""
        }
        let convertDouble = ((fromCurrency.nominalDouble! * fromCurrency.valueDauble!) / (toCurrency.nominalDouble! * toCurrency.valueDauble!)) * amount!
        return String(convertDouble)
    }
    
    // load XML
    func loadXMLFile(date: Date? ) {
        
        var strUrl = "http://www.cbr.ru/scripts/XML_daily.asp?date_req="
        
        if date !=  nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            guard let date = date else { return }
            strUrl = strUrl+dateFormatter.string(from: date)
        }
        
        let url = URL(string: strUrl)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            var errorGlobal: String?
            
            if error == nil {
                // save data
                let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]+"/data.xml"
                let urlForSave = URL(fileURLWithPath: path)
                
                do {
                    try data?.write(to: urlForSave)
                    print("Файл загружен")
                    self.parseXML()
                } catch {
                    print("Error save data: \(error.localizedDescription)")
                    errorGlobal = error.localizedDescription
                }
            } else {
                print("Error: When loadXMLFile: \(error!.localizedDescription)")
                errorGlobal = error?.localizedDescription
            }
            if let errorGlobal = errorGlobal {
                NotificationCenter.default.post(name: NSNotification.Name("ErrorWhenXMLLoading"), object: self, userInfo: ["ErrorName":errorGlobal])
            }
            
            NotificationCenter.default.post(name: NSNotification.Name("StartLoadingXML"), object: self)
        }
        task.resume()
    }
    
}

//MARK: XMLParserDelegate

extension Model: XMLParserDelegate {
    
    // parse XML
    func parseXML() {
        currencies = [Currency.rouble()]
        guard let url = urlForXML else { return }
        let parser = XMLParser(contentsOf: url)
        parser?.delegate = self
        parser?.parse()
        print("Данные обновлены")
        NotificationCenter.default.post(name: NSNotification.Name("dataRefreshed"), object: self)
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "ValCurs" {
            if let currentDateString = attributeDict["Date"] {
                currentDate = currentDateString
            }
        }
        
        if elementName == "Valute" {
            currentCurrency = Currency()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentCharacters = string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "NumCode" {
            currentCurrency?.NumCode = currentCharacters
        }
        if elementName == "CharCode" {
            currentCurrency?.CharCode = currentCharacters
        }
        if elementName == "Nominal" {
            currentCurrency?.Nominal = currentCharacters
            currentCurrency?.nominalDouble = Double(currentCharacters.replacingOccurrences(of: ",", with: "."))
        }
        if elementName == "Name" {
            currentCurrency?.Name = currentCharacters
        }
        if elementName == "Value" {
            currentCurrency?.Value = currentCharacters
            currentCurrency?.valueDauble = Double(currentCharacters.replacingOccurrences(of: ",", with: "."))
        }
        
        if elementName == "Valute" {
            currencies.append(currentCurrency!)
        }
    }
}
