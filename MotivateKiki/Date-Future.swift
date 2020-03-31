//
//  Date-Future.swift
//  MotivateKiki
//
//  Created by Srinivasan Rajendran on 2020-03-29.
//  Copyright © 2020 Srinivasan Rajendran. All rights reserved.
//

import Foundation

extension Date {
    func byAdding(days: Int) -> Self {
        var dateComponents = DateComponents()
        dateComponents.day = days
        return Calendar.current.date(byAdding: dateComponents, to: self) ?? self
    }
}
