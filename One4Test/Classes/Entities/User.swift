//
//  User.swift
//  One4Test
//
//  Created by Andrea Mario Lufino on 06/12/20.
//

import Foundation


class User: Codable {
    
    var username: String?
    var avatarURL: String?
    
    private enum CodingKeys: String, CodingKey {
        case username       = "login"
        case avatarURL      = "avatar_url"
    }
}
