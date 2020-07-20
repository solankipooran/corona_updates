//
//  CountryViewController.swift
//  CoronaUpdates
//
//  Created by POORAN SUTHAR on 03/05/20.
//  Copyright © 2020 POORAN SUTHAR. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController {
    var countryCase : [Corona] = []
    @IBOutlet weak var countryNamelbl: UILabel!
    @IBOutlet weak var newConfirmedlbl: UILabel!
    @IBOutlet weak var newRecoveredlbl: UILabel!
    @IBOutlet weak var totalRecoveredlbl: UILabel!
    @IBOutlet weak var totalDeathlbl: UILabel!
    @IBOutlet weak var newDeathlbl: UILabel!
    @IBOutlet weak var totalConfirmedlbl: UILabel!
    @IBOutlet weak var dateofUpdatelbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let nC = countryCase.first?.NewConfirmed ,
            let nR = countryCase.first?.NewRecovered ,
        let tR = countryCase.first?.TotalRecovered ,
        let nD = countryCase.first?.NewDeaths ,
        let tC = countryCase.first?.TotalConfirmed ,
        let tD = countryCase.first?.TotalDeaths else{
            return
        }
        countryNamelbl.text = countryCase.first?.Country
        newConfirmedlbl.text = "\(nC)"
        newRecoveredlbl.text = "\(nR)"
        totalRecoveredlbl.text = "\(tR)"
        totalDeathlbl.text = "\(tD)"
        newDeathlbl.text = "\(nD)"
        totalConfirmedlbl.text = "\(tC)"
        dateofUpdatelbl.text = countryCase.first?.Date
        
    }
    

  

}
