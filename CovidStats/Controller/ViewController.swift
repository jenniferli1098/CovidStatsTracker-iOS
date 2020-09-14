//
//  ViewController.swift
//  CovidStats
//
//  Created by Jennifer Liang on 2020-04-20.
//  Copyright © 2020 Jennifer Liang. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var searchTextField: CustomSearchTextField!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var activeCasesLabel: UILabel!
    @IBOutlet weak var newCasesLabel: UILabel!
    @IBOutlet weak var newDeathsLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var covidDataManager = CovidDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        covidDataManager.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        searchTextField.addTarget(self, action: #selector(ViewController.textFieldDidChange), for: .editingChanged)
        searchTextField.addTarget(self, action: #selector(ViewController.textFieldDidEndEditingOnExit), for: .editingDidEndOnExit)
        searchTextField.addTarget(self, action: #selector(ViewController.textFieldDidBeginEditing), for: .editingDidBegin)
        searchTextField.addTarget(self, action: #selector(ViewController.textFieldDidEndEditing), for: .editingDidEnd)
        buildSearchTableView()
        searchTextField.delegate = self
        
        searchTextField.clearsOnBeginEditing = false;

        self.setupToHideKeyboardOnTapOnView()
    }
    
//    override open func layoutSubviews() {
//        super.layoutSubviews()
//        buildSearchTableView()
//    }
    
    func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
//        self.searchTextField.text = ""
//        searchTextField.filter()
        searchTextField.tableView?.isHidden = true
    }
}

//MARK: CustomSearchTextFieldDelegate
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: TableViewDataSource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTextField.resultsList.count
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: TableViewDelegate methods
    // Adding rows in the tableview with the data from dataList
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSearchTextFieldCell", for: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.attributedText = searchTextField.resultsList[indexPath.row].getFormatedText()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("WTF")
        self.searchTextField.text = searchTextField.resultsList[indexPath.row].getStringText()
        tableView.isHidden = true
        self.searchTextField.endEditing(true)
    }
    
    
    
    
    
    
    func buildSearchTableView() {
        if let tableView = searchTextField.tableView {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomSearchTextFieldCell")
            searchTextField.window?.addSubview(tableView)
        } else {
//            searchTextField.addData()
            searchTextField.tableView = UITableView(frame: CGRect.zero)
            searchTextField.tableView?.delegate = self
            searchTextField.tableView?.dataSource = self
        }
        
        updateSearchTableView()
    }
    
    // Updating SearchtableView
    func updateSearchTableView() {
        
        if let tableView = searchTextField.tableView {
            searchTextField.superview?.bringSubviewToFront(tableView)
            var tableHeight: CGFloat = 0
            tableHeight = tableView.contentSize.height
            
            // Set a bottom margin of 10p
            if tableHeight < tableView.contentSize.height {
                tableHeight -= 10
            }
            
            // Set tableView frame
            var tableViewFrame = CGRect(x: 0, y: 0, width: searchTextField.frame.size.width - 4, height: tableHeight)
            tableViewFrame.origin = searchTextField.convert(tableViewFrame.origin, to: nil)
            tableViewFrame.origin.x += 2
            tableViewFrame.origin.y += searchTextField.frame.size.height + 2
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.searchTextField?.tableView?.frame = tableViewFrame
            })
            
            //Setting tableView style
            tableView.layer.masksToBounds = true
            tableView.separatorInset = UIEdgeInsets.zero
            tableView.layer.cornerRadius = 5.0
            tableView.separatorColor = UIColor.lightGray
            tableView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            
            if self.isFirstResponder {
                searchTextField.superview?.bringSubviewToFront(searchTextField)
            }
            
            tableView.reloadData()
        }
    }
    
    
    
    
    
    
    
    
    
    //MARK: - Text Field Methods
    @objc open func textFieldDidChange(){
        searchTextField.filter()
        buildSearchTableView()
        searchTextField.tableView?.isHidden = false
    }
    
    @objc open func textFieldDidEndEditingOnExit() {
    }
    
    @objc open func textFieldDidBeginEditing() {
        searchTextField.tableView?.isHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //when return key is pressed
        searchTextField.endEditing(true)
        processTypedWord()
        return true
    }
    
    @objc open func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.text != "" {
        } else {
            textField.placeholder = "Type in your region"
        }
        searchTextField.tableView?.reloadData()
    }
    
//    //checks the answer when endediting is triggered
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if textField.text != "" {
//            return true
//        } else {
//            textField.placeholder = "Type in your region"
//            return false
//        }
//    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        processTypedWord()
    }
    
    func processTypedWord() {
        if let region = searchTextField.text {
            covidDataManager.fetchCovidData(regionName: region)
        }
        searchTextField.text = ""
        resignFirstResponder()
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
            self.activeCasesLabel.text = String(data.confirmed)
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
