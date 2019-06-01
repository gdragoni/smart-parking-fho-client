//
//  Vaga.swift
//  Smart Parking
//
//  Created by Gabriel Dragoni on 24/05/19.
//  Copyright © 2019 Dragoni. All rights reserved.
//

import Foundation
import Alamofire

typealias Vagas = [Vaga]

class Vaga: Codable {
    let id: String
    let pos: String
    let disp: Disponibilidade
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case pos, disp
    }
}

enum Disponibilidade: Int, Codable {
    case disponivel = 1
    case reservada = 2
    case ocupada = 3
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - Alamofire response handlers

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try newJSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseVagas(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Vagas>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseVaga(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Vaga>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
