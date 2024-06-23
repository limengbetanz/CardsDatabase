//
//  ApiSevice.swift
//  CardsDatabase
//
//  Created by Meng Li on 20/06/2024.
//

import Foundation
import Combine

enum APIError: Error, LocalizedError {
    case decodingError(String)
    case invalidResponse(String)
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .decodingError(let message):
            return message
        case .invalidResponse(let message):
            return message
        case .serverError(let message):
            return message
        }
    }
}

protocol ApiSeviceProtocol {
    func runTask<T: Decodable>(withUrlRequest request: URLRequest) -> AnyPublisher<[T], APIError>
}

class ApiSevice: ApiSeviceProtocol {
    func runTask<T: Decodable>(withUrlRequest request: URLRequest) -> AnyPublisher<[T], APIError> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse,
                        (200...299).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: [T].self, decoder: JSONDecoder())
            .mapError { error in
                switch error {
                case is Swift.DecodingError:
                  return APIError.decodingError(error.localizedDescription)
                case is URLError:
                    return APIError.invalidResponse(error.localizedDescription)
                default:
                  return APIError.serverError(error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
}
