//
//  ViewController.swift
//  CovidStats
//
//  Created by Jennifer Liang on 2020-04-20.
//  Copyright © 2020 Jennifer Liang. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var activeCasesLabel: UILabel!
    @IBOutlet weak var newCasesLabel: UILabel!
    @IBOutlet weak var newDeathsLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var covidDataManager = CovidDataManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        covidDataManager.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    
    
}

//MARK: UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           //when return key is pressed
           print(searchTextField.text!)
           searchTextField.endEditing(true)

           return true
       }
       
       func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
           if let region = searchTextField.text {
               covidDataManager.fetchCovidData(regionName: region)
           }
           searchTextField.text = ""
           resignFirstResponder()
       }
    //checks the answer when endediting is triggered
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type in your region"
            return false
        }
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        
        print(searchTextField.text!)
        searchTextField.endEditing(true)
    }
    @IBAction func locationPressed(_ sender: UIButton) {
    }
}
//MARK: CovidDataManagerDelegate
extension ViewController: CovidDataManagerDelegate {
    func didUpdateData(data: CovidDataModel) {
        DispatchQueue.main.async {
            self.regionLabel.text = data.province
            self.countryLabel.text = data.country
            self.activeCasesLabel.text = String(data.activeCases)
            self.newCasesLabel.text = String(data.newCases)
            self.newDeathsLabel.text = String(data.newDeaths)

        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}

//MARK: CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            //update with location
            //weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
