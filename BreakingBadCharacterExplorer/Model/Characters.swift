//
//  Characters.swift
//  BreakingBadCharacterExplorer
//
//  Created by Sharaf Nazaar on 12/10/20.
//

import Foundation

// MARK: - Character
class Character: Codable {
    let charid: Int
    let name, birthday: String
    let occupation: [String]
    let img: String
    let status, nickname: String
    let appearance: [Int]?
    let portrayed, category: String
    let betterCallSaulAppearance: [Int]

    enum CodingKeys: String, CodingKey {
        case charid = "char_id"
        case name, birthday, occupation, img, status, nickname, appearance, portrayed, category
        case betterCallSaulAppearance = "better_call_saul_appearance"
    }

    init(charid: Int, name: String, birthday: String, occupation: [String], img: String, status: String, nickname: String, appearance: [Int]?, portrayed: String, category: String, betterCallSaulAppearance: [Int]) {
        self.charid = charid
        self.name = name
        self.birthday = birthday
        self.occupation = occupation
        self.img = img
        self.status = status
        self.nickname = nickname
        self.appearance = appearance
        self.portrayed = portrayed
        self.category = category
        self.betterCallSaulAppearance = betterCallSaulAppearance
    }
}

typealias Characters = [Character]
