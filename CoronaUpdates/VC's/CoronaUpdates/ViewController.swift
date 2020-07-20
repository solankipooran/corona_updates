//
//  ViewController.swift
//  CoronaUpdates
//
//  Created by POORAN SUTHAR on 03/05/20.
//  Copyright © 2020 POORAN SUTHAR. All rights reserved.
//

import UIKit
struct Cases : Codable{
    var Countries : [Corona]
}

struct Corona : Codable{
    var Country : String
    var NewConfirmed :Int
    var NewDeaths :Int
    var NewRecovered :Int
    var TotalConfirmed :Int
    var TotalDeaths :Int
    var TotalRecovered :Int
    var Date : String
}

class ViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var searchBar: UISearchBar!
    var casesDetails : [Corona] = []
    var searchedCountry : [Corona] = []
    var searchIsOn = false
    @IBOutlet var tapGestureOutlet: UITapGestureRecognizer!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newConfirmedlbl: UILabel!
    @IBOutlet weak var totalRecoveredlbl: UILabel!
    @IBOutlet weak var totalDeathlbl: UILabel!
    @IBOutlet weak var totalConfirmedlbl: UILabel!
    @IBOutlet weak var newRecoveredlbl: UILabel!
    @IBOutlet weak var newDeathlbl: UILabel!
    @IBOutlet weak var countryTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getdata()
    }
    
    func getdata(){
        let session = URLSession(configuration: URLSessionConfiguration.default)
        guard let url = URL(string: "https://api.covid19api.com/summary") else{
            return
        }
        let task =  session.dataTask(with: url) { (data, response, error) in
            if let theerror = error{
                self.showAlert(message: theerror.localizedDescription)
                return
            }
            guard let mydata = data else{
                return
            }
            
            let decoder = JSONDecoder()
            do{
                let detailedData = try decoder.decode(Cases.self, from: mydata)
                self.casesDetails = detailedData.Countries
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch{
                self.showAlert(message: error.localizedDescription)
            }
        }
        task.resume()
    }
    
}

extension ViewController : UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let nib = Bundle.main.loadNibNamed("TableViewHeader", owner: self, options: nil)?.first
        return nib as? UIView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchIsOn{
            return searchedCountry.count
        }else{
            return casesDetails.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTableViewCell") as? DetailsTableViewCell else{
            return UITableViewCell()
        }
        let caseTable = searchIsOn ?searchedCountry[indexPath.row]:casesDetails[indexPath.row]
        cell.countryNamelbl.text = caseTable.Country
        cell.totalConfirmed.text = "\(caseTable.TotalConfirmed)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let caseTable = searchIsOn ? searchedCountry[indexPath.row] : casesDetails[indexPath.row]
        countryVc(casetable: caseTable)
    }
    
    func countryVc(casetable : Corona){
        let story = UIStoryboard(name: "Main", bundle: nil)
        guard let countryVC = story.instantiateViewController(withIdentifier: "CountryViewController") as? CountryViewController else{
            return
        }
        countryVC.countryCase = [casetable]
        self.navigationController?.pushViewController(countryVC, animated: true)
        
    }
    
    func showAlert(message : String){
        let controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        controller.addAction(ok)
        DispatchQueue.main.async {
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchIsOn = false
            countryTableView.reloadData()
        }else{
            searchIsOn = true
        }
        let array = casesDetails.filter{$0.Country.lowercased().hasPrefix(searchText.lowercased())}
        print(array)
        searchedCountry = array
        countryTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchIsOn = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
