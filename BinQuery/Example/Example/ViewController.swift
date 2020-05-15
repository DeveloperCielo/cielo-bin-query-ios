//
//  ViewController.swift
//  Example
//
//  Created by Jeferson Nazario on 15/05/20.
//  Copyright © 2020 jnazario.com. All rights reserved.
//

import UIKit
import BinQuery

class ViewController: UIViewController {
    
    var query: Query?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var txtClientId: UITextField!
    @IBOutlet weak var txtClientSecret: UITextField!
    @IBOutlet weak var txtToken: UITextField!
    @IBOutlet weak var btnQuery: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnQuery.addTarget(self, action: #selector(queryCard), for: .touchUpInside)
        
        txtClientId.text = "dba3a8db-fa54-40e0-8bab-7bfb9b6f2e2e"
        txtClientSecret.text = "D/ilRsfoqHlSUChwAMnlyKdDNd7FMsM7cU/vo02REag="
        
        query = Query.instance(clientId: "", clientSecret: "")
    }

    @objc func queryCard(_ sender: UIButton) {
        query?.query(bin: "", completion: {[weak self] (response, error) in
            do {
                let jsonData = try JSONEncoder().encode(response)
                let json = String(data: jsonData, encoding: .utf8)
                
                self?.textView.text = json
                
            } catch let ex {
                debugPrint(ex.localizedDescription)
            }
        })
    }

}
