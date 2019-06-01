//
//  Webservice.swift
//  Smart Parking
//
//  Created by Gabriel Dragoni on 24/05/19.
//  Copyright © 2019 Dragoni. All rights reserved.
//

import Foundation
import Alamofire

class Webservice {
    
    static var baseURL = "https://smartparkingfho.herokuapp.com/"
    
    static func getVagas(disponibilidade: Disponibilidade, onSucces: @escaping (Vagas) -> Void, onError: @escaping (String) -> Void) {
        Alamofire.request("\(baseURL)vagas?disp=\(disponibilidade.rawValue)", method: .get).responseVagas(completionHandler: { completion in
            switch completion.result {
            case .success(let result):
                onSucces(result)
                break
            case .failure(let error):
                onError(error.localizedDescription)
                break
            }
        })
    }
    
    static func getVaga(pos: String, onSucces: @escaping (Vaga) -> Void, onError: @escaping (String) -> Void) {
        Alamofire.request("\(baseURL)vagas?pos=\(pos)", method: .get).responseVaga(completionHandler: { completion in
            switch completion.result {
            case .success(let result):
                onSucces(result)
                break
            case .failure(let error):
                onError(error.localizedDescription)
                break
            }
        })
    }
    
    static func putVaga(id: String, disponibilidade: Disponibilidade) {
        Alamofire.request("\(baseURL)vagas/\(id)", method: .put, parameters: [
            "disp": NSNumber(value: disponibilidade.rawValue)
            ], encoding: JSONEncoding.default).responseJSON(completionHandler: { completion in
                switch completion.result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
    }
}
