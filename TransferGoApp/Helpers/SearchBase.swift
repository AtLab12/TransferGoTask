//
//  SearchBase.swift
//  TransferGoApp
//
//  Created by Mikolaj Zawada on 02/03/2024.
//

import Foundation

final class SearchBase {
    private var data: [String : [UUID]]
    
    init(data: [String : [UUID]]) {
        self.data = data
    }
    
    public init(){
        self.data = [:]
    }
    
    public func search(
        phrase: String,
        levDistance: Int = 4
    ) -> [UUID] {
        // check if there is a match
        if let result = data[phrase] {
            return result
        }    else {
            // calculate levenstein for every key
            var result = data.compactMap { key, value in
                let distance = key.levenshtein(phrase)
                if distance <= levDistance {
                    return (distance, value)
                }    else {
                    return nil
                }
            }
            result.sort(by: { $0.0 < $1.0 })
            var searchResult: [UUID] = []
            result.forEach { val in
                searchResult.append(contentsOf: val.1)
            }
            return searchResult
        }
    }
    
    public func updateSearchBase(currencies: [Currency]) {
        var newData: [String : [UUID]] = [:]
        
        currencies.forEach {
            // Support search by acronym
            if var idsAcronym = newData[$0.acronym] {
                idsAcronym.append($0.id)
                newData[$0.acronym] = idsAcronym
            } else {
                newData[$0.acronym] = [$0.id]
            }
            
            // Support search by country
            if var idsCountry = newData[$0.country] {
                idsCountry.append($0.id)
                newData[$0.country] = idsCountry
            } else {
                newData[$0.country] = [$0.id]
            }
            
            // Support search by fullname
            if var idsFullName = newData[$0.fullName] {
                idsFullName.append($0.id)
                newData[$0.fullName] = idsFullName
            } else {
                newData[$0.fullName] = [$0.id]
            }
        }
        self.data = newData
    }
}
