//
//  Struct.swift
//  Exchange Alamofire
//
//  Created by Ярослав Акулов on 11.11.2021.
//

import Foundation

struct WebsiteDescription: Decodable {
    let date: Date?
    let valute: [String: ValuteDescription]?
    
    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case valute = "Valute"
    }
}

struct ValuteDescription: Decodable {
    let charCode: String?
    let nominal: Int?
    let name: String?
    let value: Double?
    let previousValue: Double?
    
    enum CodingKeys: String, CodingKey {
        case charCode = "CharCode"
        case nominal = "Nominal"
        case name = "Name"
        case value = "Value"
        case previousValue = "Previous"
    }
}
