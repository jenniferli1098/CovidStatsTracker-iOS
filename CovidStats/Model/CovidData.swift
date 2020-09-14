//
//  CovidDataModel.swift
//  CovidStats
//
//  Created by Jennifer Liang on 2020-04-20.
//  Copyright © 2020 Jennifer Liang. All rights reserved.
//

import Foundation

struct CovidData: Decodable {
    let data: [Data]
    
}
struct Data: Decodable {
    let active: Int
    let confirmed: Int //total in history
    let deaths: Int
    let confirmed_diff: Int
    let deaths_diff: Int
    let fatality_rate: Double
    let region: Region
}
struct Region: Decodable {
    let name: String
    let province: String
}
