//
//  SearchBaseTests.swift
//  TransferGoAppTests
//
//  Created by Mikolaj Zawada on 03/03/2024.
//

import XCTest
@testable import TransferGoApp

final class SearchBaseTests: XCTestCase {
    var searchBase: SearchBase!
    
    override func setUpWithError() throws {
        super.setUp()
        searchBase = SearchBase()
    }
    
    override func tearDownWithError() throws {
        searchBase = nil
        super.tearDown()
    }
    
    func testSearchWithExactMatch() {
        let currencyID = UUID()
        searchBase.updateSearchBase(currencies: [Currency(acronym: "PLN", flag: UIImage(resource: .plImg), id: currencyID, sendingLimit: 20000, country: "Poland", fullName: "Polish zloty")])
        
        let results = searchBase.search(phrase: "PLN")
        XCTAssertEqual(results.count, 1, "Should find one match")
        XCTAssertEqual(results.first, currencyID)
    }
    
    func testSearchWithPartialMatchWithinLevenshteinDistance() {
        let currencyID = UUID()
        searchBase.updateSearchBase(currencies: [Currency(acronym: "EUR", flag: UIImage(), id: currencyID, sendingLimit: 500, country: "Germany", fullName: "Euro")])
        
        let results = searchBase.search(phrase: "EUD", levDistance: 1)
        XCTAssertEqual(results.count, 1, "Should find one match within a distance of 1")
        XCTAssertEqual(results.first, currencyID)
    }
    
    func testSearchWithMultipleMatches() {
        let currencyID1 = UUID()
        let currencyID2 = UUID()
        searchBase.updateSearchBase(currencies: [
            Currency(acronym: "GBP", flag: UIImage(resource: .gbImg), id: currencyID1, sendingLimit: 1000, country: "Great Britain", fullName: "British Pound"),
            Currency(acronym: "EUR", flag: UIImage(resource: .deImg), id: currencyID2, sendingLimit: 5000, country: "Germany", fullName: "Euro")
        ])
        
        let results = searchBase.search(phrase: "Great", levDistance: 4)
        XCTAssertEqual(results.count, 2)
        XCTAssertTrue(results.contains(currencyID1))
        XCTAssertTrue(results.contains(currencyID2))
    }
    
    func testSearchUpdatesWithNewData() {
        let currencyID = UUID()
        searchBase.updateSearchBase(currencies: [Currency(acronym: "AUD", flag: UIImage(), id: currencyID, sendingLimit: 1500, country: "Australia", fullName: "Australian Dollar")])
        
        var results = searchBase.search(phrase: "AUD")
        XCTAssertEqual(results.count, 1, "Should find one match for 'AUD'")
        
        let newCurrencyID = UUID()
        searchBase.updateSearchBase(currencies: [Currency(acronym: "CAD", flag: UIImage(), id: newCurrencyID, sendingLimit: 1000, country: "Canada", fullName: "Canadian Dollar")])
        
        results = searchBase.search(phrase: "CAD")
        XCTAssertEqual(results.count, 1, "Should find one match for 'CAD' after updating data")
        XCTAssertEqual(results.first, newCurrencyID)
    }
}
