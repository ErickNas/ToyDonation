//
//  ToyItem.swift
//  ToyDonation
//
//  Created by Erick on 16/07/22.
//

import Foundation

struct ToyItem {
    var id: String
    var toyName: String
    var donatorName: String
    var address: String
    var phoneNumber: String
    var toyState: Int
    
    var condition: String {
        switch toyState {
        case 0:
            return "Novo"
        case 1:
            return "Usado"
        default:
            return "Precisa de Reparo"
        }
    }
}
