//
//  ImagesManager.swift
//  CoverFlow
//
//  Created by Vladimir on 26/10/2020.
//  Copyright © 2020 Embler. All rights reserved.
//

import Foundation

class ImageManager {
    // MARK: - Static properties
    static let shared = ImageManager()
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Mthods
    func getImagesName() -> [String] {
        guard var resourcePath = Bundle.main.resourcePath else { return [] }
        resourcePath = resourcePath + "/Covers"
        let fileManager = FileManager.default
        let items = try! fileManager.contentsOfDirectory(atPath: resourcePath)
        return items.filter{$0.hasSuffix("jpg")}.sorted(by: < )
    }
}
