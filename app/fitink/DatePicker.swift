//
//  DatePicker.swift
//  fitink
//
//  Created by Manuel on 17/12/20.
//

import UIKit
import Foundation

extension UIDatePicker {

   func setDate(from string: String, format: String, animated: Bool = true) {

      let formater = DateFormatter()

      formater.dateFormat = format

      let date = formater.date(from: string) ?? Date()

      setDate(date, animated: animated)
   }
}
