//
//  NumberFormatter.swift
//  Food
//
//  Created by Lac Tuan on 2/28/18.
//  Copyright © 2018 Lac Tuan. All rights reserved.
//

import UIKit


extension NumberFormatter {
    convenience init(numberStyle: NumberFormatter.Style) {
        self.init()
        self.numberStyle = numberStyle
    }
}
struct Formatter {
    static let decimal = NumberFormatter(numberStyle: .decimal)
}
extension UITextField {
    var string: String { return text ?? "" }
}

extension String {
    private static var digitsPattern = UnicodeScalar("0")..."9"
    var digits: String {
        return unicodeScalars.filter { String.digitsPattern ~= $0 }.string
    }
    var integer: Int { return Int(self) ?? 0 }
}

extension Sequence where Iterator.Element == UnicodeScalar {
    var string: String { return String(String.UnicodeScalarView(self)) }
}
