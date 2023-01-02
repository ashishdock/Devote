//
//  CheckboxStyle.swift
//  Devote
//
//  Created by Ashish Sharma on 01/02/2023.
//

import SwiftUI

struct CheckboxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .foregroundColor(configuration.isOn ? .pink : .primary)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .onTapGesture {
                    configuration.isOn.toggle()
                    feedback.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.success)
                    if configuration.isOn {
                        playSound(sound: "sound-rise", type: "mp3")
                    } else {
                        playSound(sound: "sound-tap", type: "mp3")
                    }
                    
                }
            configuration.label
        }//: HStack
    }
}
//
//struct CheckboxStyle_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckboxStyle()
//    }
//}
