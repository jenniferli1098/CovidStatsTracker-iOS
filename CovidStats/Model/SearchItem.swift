//
//  SearchItem.swift
//  CovidStats
//
//  Created by Henry Tang.
//  Copyright © 2020 Henry Tang. All rights reserved.
//

import Foundation

class SearchItem {
    var attributedCityName: NSMutableAttributedString?
    var attributedRegionName: NSMutableAttributedString?
    var attributedCountryName: NSMutableAttributedString?
    var allAttributedName : NSMutableAttributedString?
    
    var cityName: String
    var regionName: String
    var countryName: String

    public init(cityName: String, regionName: String, countryName: String) {
        self.cityName = cityName
        self.countryName = countryName
        self.regionName = regionName
    }
    
    public func getFormatedText() -> NSMutableAttributedString{
        allAttributedName = NSMutableAttributedString()
        if let name = attributedCityName {
            allAttributedName!.append(name)
            allAttributedName!.append(NSMutableAttributedString(string: ", "))
        }
        if let name = attributedRegionName {
            allAttributedName!.append(name)
            allAttributedName!.append(NSMutableAttributedString(string: ", "))
        }
        allAttributedName!.append(attributedCountryName!)
        
        return allAttributedName!
    }
    
    public func getStringText() -> String{
        return "\(cityName), \(regionName), \(countryName)"
    }

}
