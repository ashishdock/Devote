//
//  HideKeyboard.swift
//  Devote
//
//  Created by Ashish Sharma on 01/02/2023.
//

import SwiftUI
import UIKit

#if canImport(UIKit)

extension View {
    func hideKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
