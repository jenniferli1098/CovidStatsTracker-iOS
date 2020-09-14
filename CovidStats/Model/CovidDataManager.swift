//
//  CovidDataManager.swift
//  CovidStats
//
//  Created by Jennifer Liang on 2020-04-20.
//  Copyright © 2020 Jennifer Liang. All rights reserved.
//

import Foundation
import CoreLocation


protocol CovidDataManagerDelegate {
    func didUpdateData(data: CovidDataModel)
    func didFailWithError(error: Error)
}

struct CovidDataManager {
    let covidURL = "https://covid-api.com/api/reports?"
    let urlString = "https://api.covid19api.com/summary"
    var delegate: CovidDataManagerDelegate?
    
    func fetchCovidData (regionName: String){
        let query = regionName.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(covidURL)&q=\(query)"
        print(urlString)
        self.performRequest(with: urlString)
    }
    /*
    func fetchCovidData (latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(covidURL)&lat=\(latitude)&lon=\(longitude)"
        self.performRequest(with: urlString)
    }*/
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            //create a url session
            let session = URLSession(configuration: .default)
            
            //give session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    //let dataString = String(data: safeData, encoding: .utf8)
                    if let covidData = self.parseJSON(safeData) {
                        self.delegate?.didUpdateData(data: covidData)
                    }
                }
            }
            
            //start task
            task.resume()
            
        }
    }
    
    func parseJSON (_ covidData: Foundation.Data) -> CovidDataModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CovidData.self, from: covidData)
            /*
            if decodedData.data.count == 0 {
                self.delegate?.didFailWithError(error: Error)
                return nil
            }*/
            let result = decodedData.data[0]
            let province = result.region.province
            let country = result.region.name
            let active_cases = result.active
            let confirmed = result.confirmed
            //let deaths = decodedData.deaths
            let new_cases = result.confirmed_diff
            let new_deaths = result.deaths_diff
            let fatality_rate = result.fatality_rate
            
            return CovidDataModel(province: province, confirmed: confirmed, country: country, activeCases: active_cases, newCases: new_cases, newDeaths: new_deaths, fatalityRate: fatality_rate)
            
        } catch {
            self.delegate?.didFailWithError(error: error)

            return nil
        }
        
    }
    
    
    
}
extension String: LocalizedError {
    public var errorDescription: String? {return self}
}
