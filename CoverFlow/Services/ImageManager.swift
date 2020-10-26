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
        var imagesName: [String] = []
        let fileManager = FileManager.default
        guard let resourcePath = Bundle.main.resourcePath else { return [] }
        let items = try! fileManager.contentsOfDirectory(atPath: resourcePath)
        imagesName = items.filter{$0.hasSuffix("jpg")}.sorted(by: < )
        return imagesName
    }
}
