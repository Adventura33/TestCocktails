//
//  UserDefaultsManager.swift
//  TestApplication
//
//  Created by Sharapat Azamat on 21.04.2024.
//

import Foundation

struct UserDefaultsManager {
    
    static func saveNonAlcoholicList(_ list: [Drink]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(list)
            UserDefaults.standard.set(data, forKey: "CachedNonAlcoholicList")
        } catch {
            print("Error saving non-alcoholic list to UserDefaults: \(error.localizedDescription)")
        }
    }
    
    static func loadNonAlcoholicList() -> [Drink] {
        if let data = UserDefaults.standard.data(forKey: "CachedNonAlcoholicList") {
            do {
                let decoder = JSONDecoder()
                let list = try decoder.decode([Drink].self, from: data)
                return list
            } catch {
                print("Error loading non-alcoholic list from UserDefaults: \(error.localizedDescription)")
            }
        }
        return []
    }
    
    static func saveAlcoholicList(_ list: [Drink]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(list)
            UserDefaults.standard.set(data, forKey: "CachedAlcoholicList")
        } catch {
            print("Error saving alcoholic list to UserDefaults: \(error.localizedDescription)")
        }
    }
    
    static func loadAlcoholicList() -> [Drink] {
        if let data = UserDefaults.standard.data(forKey: "CachedAlcoholicList") {
            do {
                let decoder = JSONDecoder()
                let list = try decoder.decode([Drink].self, from: data)
                return list
            } catch {
                print("Error loading alcoholic list from UserDefaults: \(error.localizedDescription)")
            }
        }
        return []
    }
    
    static func clearLists() {
        UserDefaults.standard.removeObject(forKey: "CachedNonAlcoholicList")
        UserDefaults.standard.removeObject(forKey: "CachedAlcoholicList")
    }
}
