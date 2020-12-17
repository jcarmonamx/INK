//
//  Structs.swift
//  SafePeople
//
//  Created by Manuel on 16/05/20.
//  Copyright © 2020 Secunet. All rights reserved.
//

import Foundation

class Structs {
    
    struct User:Codable {
        let id:Int
        let name:String
        let email:String
        let fecha_nacimiento:String
        let telefono:String
        let genero:String
        let estatura:String
        let peso:String
        let complexion:String
        let fruta:Int
        let agua:Int
        let carne_roja:Int
        let cereales:Int
        let carne_blanca:Int
        let verduras:Int
        let azucares:Int
        let chatarra:Int
        let condicion:String
    }
    
}

