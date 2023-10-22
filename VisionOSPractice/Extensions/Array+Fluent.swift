//
//  Array+Fluent.swift
//  VisionOSPractice
//
//  Created by Chiaote Ni on 2023/10/24.
//

import Foundation

extension Array {

    func filterOutFirst(_ k: Int) -> Self {
        var result = self
        result.removeFirst(k)
        return result
    }
}
