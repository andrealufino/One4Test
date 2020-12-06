//
//  UIViewController+APIError.swift
//  One4Test
//
//  Created by Andrea Mario Lufino on 06/12/20.
//

import Foundation
import UIKit


extension UIViewController {
    
    func showAlert(withError error: APIError, title: String = "Error") {
        
        _ = showAlert(title: title, message: error.userMessage, buttonTitles: ["Ok"])
    }
}
