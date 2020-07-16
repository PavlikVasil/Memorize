//
//  Array+Only.swift
//  Memorize
//
//  Created by Павел on 6/22/20.
//  Copyright © 2020 Павел. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
