//
//  ViewController.swift
//  Example
//
//  Created by Jeferson Nazario on 15/05/20.
//  Copyright © 2020 jnazario.com. All rights reserved.
//

import UIKit
import CieloBinQuery

class ViewController: UIViewController {
    
    var query: Query?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var txtMerchantId: UITextField!
    @IBOutlet weak var txtClientId: UITextField!
    @IBOutlet weak var txtClientSecret: UITextField!
    @IBOutlet weak var txtToken: UITextField!
    @IBOutlet weak var txtCard: UITextField!
    @IBOutlet weak var btnQuery: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnQuery.addTarget(self, action: #selector(queryCard), for: .touchUpInside)
        
        txtMerchantId.text = "A0BE879C-D2C1-486B-BA0A-04B6D4D7028E"
        txtClientId.text = "2494d738-a82e-496e-8adc-5e0265b5dcec"
        txtClientSecret.text = "Rqat2ohHS9FQbXwuXKk9Pksm1ICb9N2pvzh7WD6Yarw="
        txtCard.text = "501010"
        
        query = Query.instance(clientId: txtClientId.text!, clientSecret: txtClientSecret.text!, environment: .sandbox)
    }

    @objc func queryCard(_ sender: UIButton) {
        self.view.endEditing(true)
        self.textView.text = ""
        
        guard let cardbin = txtCard.text, cardbin.count > 5 else {
            self.textView.text = "Informe os 6 primeiros dígitos do cartão a ser consultado."
            return
        }
        
        query?.query(bin: cardbin, completion: {[weak self] (response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    self?.textView.text = error
                    return
                }
                
                do {
                    let jsonData = try JSONEncoder().encode(response)
                    let json = String(data: jsonData, encoding: .utf8)
                    
                    
                    self?.textView.text = json
                    
                    
                } catch let ex {
                    self?.textView.text = ex.localizedDescription
                }
            }
        })
    }

}
