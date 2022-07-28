//
//  HeroesData.swift
//  MarvelHeroFinder
//
//  Created by Kevin Martinez on 3/19/22.
//

import Foundation

struct CharacterDataWrapper: Codable {
    let data: data
}

struct data: Codable {
    let results: [results]
}

struct results: Codable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: thumbnail
}

struct thumbnail: Codable {
    let path: String
    let `extension`: String
}


