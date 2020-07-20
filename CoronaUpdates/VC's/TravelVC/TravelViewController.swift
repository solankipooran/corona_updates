//
//  TravelViewController.swift
//  CoronaUpdates
//
//  Created by POORAN SUTHAR on 18/05/20.
//  Copyright © 2020 POORAN SUTHAR. All rights reserved.
//

import UIKit

class TravelViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationsStorage.shared.addObserver(obserer: self)
        // Do any additional setup after loading the view.
    }

    deinit {
        LocationsStorage.shared.removeObserver(observer: self)
    }
}

extension TravelViewController : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationsStorage.shared.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        let location = LocationsStorage.shared.locations.reversed()[indexPath.row]
        cell.textLabel?.numberOfLines = 4
        cell.textLabel?.text = location.description
        cell.detailTextLabel?.text = location.dateString
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

extension TravelViewController : LocationObserver {
    func locationAdded() {
        tableView.reloadData()
    }
}
