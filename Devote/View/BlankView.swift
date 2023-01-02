//
//  BlankView.swift
//  Devote
//
//  Created by Ashish Sharma on 01/02/2023.
//

import SwiftUI

struct BlankView: View {
    //MARK: - PROPERTIES
    var backgroundColor: Color
    var backgroundOpacity: Double
    
    
    //MARK: - BODY
    
    var body: some View {
        VStack{
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(backgroundColor)
        .opacity(backgroundOpacity)
        .blendMode(BlendMode.overlay)
        .edgesIgnoringSafeArea(.all)
    }
}

//MARK: - PREVIEW

//struct BlankView_Previews: PreviewProvider {
//    static var previews: some View {
//        BlankView()
//    }
//}
