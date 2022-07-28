//
//  HeroesManager.swift
//  MarvelHeroFinder
//
//  Created by Kevin Martinez on 3/19/22.
//

import Foundation

protocol HeroManagerDelegate {
    func didUpdateHero (_ heroManager: HeroesManager, hero: HeroModel)
    func didFailWithError(error: Error)
}

struct HeroesManager {
    
    var delegate: HeroManagerDelegate?
    let marvelUrl = CreateURL.createURL()
    
    
    func fetchHero(name: String, limit: Int = 100){
        let urlSearText = name.replacingOccurrences(of: " ", with: "%20")
        let url = "\(marvelUrl)&nameStartsWith=\(urlSearText)&limit=\(limit)"
        performRequest(with: url, offeset: 0)
    }
    
    func performRequest(with urlString: String = CreateURL.createURL(), limit: Int = 100, offeset: Int = Int.random(in: 1...1460) ){
        
        if let url = URL(string: urlString + "&limit=\(limit)&offset=\(offeset)"){
            let sessions = URLSession(configuration: .default)
            let task = sessions.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                }
                
                if let safeData = data {
                    if let hero = self.parseJSON(safeData) {
                        self.delegate?.didUpdateHero(self, hero: hero)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ heroData: Data) -> HeroModel? {
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(CharacterDataWrapper.self, from: heroData)
            let result = decodeData.data.results
            let hero =  HeroModel(CharacterResult: result)
            heroResults = result
            return hero
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
