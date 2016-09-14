//
//  APIHelper.swift
//  State App
//
//  Created by Neil on 9/13/16.
//  Copyright © 2016 Neil. All rights reserved.
//
//  Class will pull data from an REST API. 
//  Class will then call protocal method when data is available.
//  The REST API is available at https://github.com/r-neil/StatesApp-backend
//



import Foundation

protocol FetchStateData{
    func stateDataReady(stateData:StateDataStruct)
    func noDataReturned()
}


//using a struct to hold data from API. Struct will then be passed in the delegate method call.
//If additional data values are available from API this method along with createStateDataDictionary() and APIKey
// will need to be updated.
struct StateDataStruct{
    var stateName : String?
    var stateAbbrev : String?
    var capital : String?
    var population : String?
    var popRank : Int?
    var joinedUnion : String?
    var nicknames : String?
}

class APIHelper{
    
    var dataDelegate : FetchStateData?
    
    //API URL and Keys
    private var APIStr : String?
    private var dataAPIURL : NSURL{
        get{
            return NSURL(string: APIStr!)!
        }
    }
    
    //Keys from the https://github.com/r-neil/StatesApp-backend API.
    //If names change, this Struct will need to be updated.
    private struct APIKeys{
        static let stateName = "state_name"
        static let stateAbbrev = "state_abbrev"
        static let capital = "capital"
        static let pop = "population"
        static let popRank = "population_rank"
        static let joined = "joined_union"
        static let nickname = "nicknames"
    }
    
    
    init(stateValue:String){
        APIStr = stateValue.createAPIStr
        fetchAPIData()
    }
    
    private func fetchAPIData(){
        let dataTask = NSURLSession.sharedSession().dataTaskWithURL(dataAPIURL) { (data, response, error) in
            if data != nil{
                do{
                    let stateData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    guard let stateDataDictionary = (stateData as? NSArray)?.firstObject as? NSDictionary
                    else{
                        print("unable to convert API data to NSDictionary")
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.dataDelegate?.noDataReturned()
                        })
                        return
                    }
                    self.createStateDataDictionary(stateDataDictionary)
                }
                catch{
                    print("data error with data source API")
                }
            }
            else{
                print("no data from source")
            }
        }
        
        dataTask.resume()
        
    }
    
    private func createStateDataDictionary(data:NSDictionary){
        var stateData = StateDataStruct()
        stateData.stateName = data.valueForKey(APIKeys.stateName) as? String ?? " "
        stateData.stateAbbrev = data.valueForKey(APIKeys.stateAbbrev) as? String ?? " "
        stateData.popRank = data.valueForKey(APIKeys.popRank) as? Int ?? 0
        stateData.population = data.valueForKey(APIKeys.pop) as? String ?? " "
        stateData.capital = data.valueForKey(APIKeys.capital) as? String ?? " "
        stateData.nicknames = data.valueForKey(APIKeys.nickname) as? String ?? " "
        stateData.joinedUnion = data.valueForKey(APIKeys.joined) as? String ?? " "
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.dataDelegate?.stateDataReady(stateData)
        })
    }
}


/**
 Extention created string of a URL used to retrieve state data.
 Update the "http" string below to change where App will pull State Data.
 
 - parameter String:
 - returns: String of URL for pull data.
 */
extension String{
    var createAPIStr: String {return "https://stateapp.herokuapp.com/" + self}
}

