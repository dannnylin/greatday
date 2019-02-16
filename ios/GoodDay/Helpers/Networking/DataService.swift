//
//  DataService.swift
//  GoodDay
//
//  Created by Danny on 2/15/19.
//  Copyright © 2019 dannylin. All rights reserved.
//

import Foundation
import Alamofire

class DataService {
    static let instance = DataService()
    
    func addMoodToDate(mood: Mood) {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateTime = Date()
        let dateString = dateFormatter.string(from: dateTime)
        let interval = dateTime.timeIntervalSince1970
        var data: [String: Any] = [
            "date": dateString,
            "mood": mood.description
        ]
        
        Alamofire.request(BASE_URL + "addMoodToDate", method: .post, parameters: data,  encoding: JSONEncoding.default, headers: [:]).responseString { (response) in
        switch response.result {
        case .success(let data):
            print(data)
        case .failure(let error):
            print(error)
        }
        }
    }
}
