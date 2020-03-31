//
//  BundleDecoding.swift
//  MotivateKiki
//
//  Created by Srinivasan Rajendran on 2020-03-29.
//  Copyright © 2020 Srinivasan Rajendran. All rights reserved.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate file in app bundle")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) in app bundle")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from app bundle")
        }

        return loaded
    }
}
