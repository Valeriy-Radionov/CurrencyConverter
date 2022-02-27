//
//  ConverterViewController.swift
//  CurrencyConverter
//
//  Created by Valera on 26.02.22.
//

import UIKit

class ConverterViewController: UIViewController {

    @IBOutlet weak var labelCoursesForDate: UILabel!
    
    @IBOutlet weak var buttonFrom: UIButton!
    @IBOutlet weak var buttonTo: UIButton!
    
    @IBAction func pushFromAction(_ sender: Any) {
        guard let nc = storyboard?.instantiateViewController(withIdentifier: "SelectedCurrencyNSID") as? UINavigationController else { return }
        (nc.viewControllers[0] as! SelectCurrencyController).flagCurrency = .from
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true, completion: nil)
    }
    @IBAction func pushToAction(_ sender: Any) {
        guard let nc = storyboard?.instantiateViewController(withIdentifier: "SelectedCurrencyNSID") as? UINavigationController else { return }
        (nc.viewControllers[0] as! SelectCurrencyController).flagCurrency = .to
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var textFrom: UITextField!
    @IBOutlet weak var textTo: UITextField!
    
    @IBAction func textFromEditingChange(_ sender: Any) {
        let amount = Double(textFrom.text!) 
            textTo.text = Model.shared.convert(amount: amount)
    }
    @IBAction func textToEditingChange(_ sender: Any) {
        let amount = Double(textTo.text!)
        textFrom.text = Model.shared.convert(amount: amount)
    }
    
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    @IBAction func pushDoneAction(_ sender: Any) {
        textFrom.resignFirstResponder()
        textTo.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        textFrom.delegate = self
        textTo.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelCoursesForDate.text = "Курсы валют на сегодня"
        refreshButtons()
        updateIntarface()
        textToEditingChange(self)
        textFromEditingChange(self)
        navigationItem.rightBarButtonItem = nil 
    }
    
    func updateIntarface() {
        self.buttonFrom.layer.cornerRadius = 10
        self.buttonTo.layer.cornerRadius = 10
    }
    
    func refreshButtons() {
        buttonFrom.setTitle(Model.shared.fromCurrency.CharCode, for: .normal)
        buttonTo.setTitle(Model.shared.toCurrency.CharCode, for: .normal)
    }
 
}

extension ConverterViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        navigationItem.rightBarButtonItem = buttonDone
        return true
    }
}
