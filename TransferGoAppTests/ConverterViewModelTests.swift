//
//  ConverterViewModelTests.swift
//  TransferGoAppTests
//
//  Created by Mikolaj Zawada on 03/03/2024.
//

import XCTest
import Combine
@testable import TransferGoApp

class MockNetworkingService: NetworkingService {
    var mockData: Data?
    var mockError: Error?

    func fetchData(from url: URL) -> AnyPublisher<Data, Error> {
        if let mockError = mockError {
            return Fail(error: mockError).eraseToAnyPublisher()
        }
        return Just(mockData ?? Data()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}


class ConverterViewModelTests: XCTestCase {
    var viewModel: ConverterViewModel!
    var mockNetworkingService: MockNetworkingService!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        super.setUp()
        mockNetworkingService = MockNetworkingService()
        let mockApiClient = ApiClient(networkingService: mockNetworkingService)
        viewModel = ConverterViewModel(apiClient: mockApiClient)
        cancellables = []
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockNetworkingService = nil
        cancellables = nil
        super.tearDown()
    }

    func testUpdateRateSuccess() {
        let rateResponse = RateResponse(from: "PLN", to: "UAH", rate: 0.85, fromAmount: 100.00, toAmount: 85.00)
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(rateResponse) {
            mockNetworkingService.mockData = encodedData
        }

        let expectation = self.expectation(description: "Rate update success")
        
        
        viewModel.$toAmount
            .dropFirst()
            .sink { receivedAmount in
                XCTAssertEqual(receivedAmount, String(rateResponse.toAmount), "Updated rate amount does not match expected value.")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.updateRate(initiatedBy: .from)

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testUpdateRateFailure() {
        mockNetworkingService.mockError = ApiClient.ApiClientError.failedToContructURL
        
        let expectation = self.expectation(description: "Handle network error")
        
        viewModel.$error
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error, "Error was not handled correctly.")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.updateRate()
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testCurrencySwitch() {
        let initialFromCurrency = Currency(acronym: "PLN", flag: UIImage(resource: .plImg), id: UUID(), sendingLimit: 20000, country: "Poland", fullName: "Polish zloty")
        let initialToCurrency = Currency(acronym: "UAH", flag: UIImage(resource: .uaImg), id: UUID(), sendingLimit: 50000, country: "Ukraine", fullName: "Hrivna")
        viewModel.fromCurrency = initialFromCurrency
        viewModel.toCurrency = initialToCurrency
        viewModel.fromAmount = "100"
        viewModel.toAmount = "85"

        viewModel.swapCurrencies()

        XCTAssertEqual(viewModel.fromCurrency, initialToCurrency, "The 'fromCurrency' after swap should match the initial 'toCurrency'.")
        XCTAssertEqual(viewModel.toCurrency, initialFromCurrency, "The 'toCurrency' after swap should match the initial 'fromCurrency'.")
    }
}

