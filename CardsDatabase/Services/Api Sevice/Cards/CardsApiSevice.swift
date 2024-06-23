//
//  CardsApiSevice.swift
//  CardsDatabase
//
//  Created by Meng Li on 20/06/2024.
//

import Foundation
import Combine

protocol CardsApiSeviceProtocol {
    func fetchCards(pageNumber: Int, pageSize: Int) -> AnyPublisher<[Card], APIError>
}

class CardsApiSevice: CardsApiSeviceProtocol {
    private let apiSevice: ApiSeviceProtocol
    
    var baseUrl: URL {
        return URL(string: "https://random-data-api.com/")!
    }
    
    init(apiSevice: ApiSeviceProtocol) {
        self.apiSevice = apiSevice
    }
    
    func fetchCards(pageNumber: Int, pageSize: Int) -> AnyPublisher<[Card], APIError> {
        var url = baseUrl.appendingPathComponent("api/v2/credit_cards")
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "size", value: String(pageSize)))
        queryItems.append(URLQueryItem(name: "page", value: String(pageNumber)))
        
        url.append(queryItems: queryItems)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let publisher: AnyPublisher<[Card], APIError> = apiSevice.runTask(withUrlRequest: request)
        return publisher
    }
}
