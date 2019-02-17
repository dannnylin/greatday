//
//  DataService.swift
//  GoodDay
//
//  Created by Danny on 2/15/19.
//  Copyright © 2019 dannylin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

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
    
    func getInfoForDate(data: [String: Any], complete:@escaping (_ data: JSON) -> Void) {
        var returnData: JSON? = nil
        Alamofire.request(BASE_URL + "getDateInfo", method: .post, parameters: data,  encoding: JSONEncoding.default, headers: [:]).responseJSON { (response) in
            switch response.result {
            case .success(let _):
                let jsonData = JSON(response.result.value!)
                returnData = jsonData
                complete(returnData!)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getStats(complete:@escaping (_ data: JSON) -> Void) {
        var returnData: JSON? = nil
        Alamofire.request(BASE_URL + "getStats", method: .get,  encoding: JSONEncoding.default, headers: [:]).responseJSON { (response) in
            switch response.result {
            case .success(let _):
                let jsonData = JSON(response.result.value!)
                returnData = jsonData
                complete(returnData!)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getRecommendedActivities(complete:@escaping (_ data: JSON) -> Void) {
        var returnData: JSON? = nil
        Alamofire.request(BASE_URL + "getRecommended", method: .get,  encoding: JSONEncoding.default, headers: [:]).responseJSON { (response) in
            switch response.result {
            case .success(let _):
                let jsonData = JSON(response.result.value!)
                returnData = jsonData
                complete(returnData!)
            case .failure(let error):
                print(error)
            }
        }
    }
}
