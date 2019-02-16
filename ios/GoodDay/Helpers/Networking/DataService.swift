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
    
    func addMoodToDate(mood: Mood, date: String?) {
        var dateString: String? = date
        if date == nil {
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateTime = Date()
            dateString = dateFormatter.string(from: dateTime)
        }
        let data: [String: Any] = [
            "date": dateString!,
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
    
    func addActivity(data: [String: Any]) {
        Alamofire.request(BASE_URL + "addActivity", method: .post, parameters: data,  encoding: JSONEncoding.default, headers: [:]).responseString { (response) in
            switch response.result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
