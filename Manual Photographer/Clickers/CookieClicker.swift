//
//  CookieClicker.swift
//
//  Created by Maksim on 10/27/23.
//

import SwiftUI

struct CookieClicker: View {
    @State private var scale: Double = 1.0
    
    
    var body: some View {
        VStack {
            Cookie().scaleEffect(scale)
                .animation(/*@START_MENU_TOKEN@*/.bouncy/*@END_MENU_TOKEN@*/, value: scale)
            
            HStack {
                Button {
                    scale += 0.3
                } label: {
                    Image(systemName: "arcade.stick")
                }.buttonStyle(.borderedProminent)
                    .tint(.red)
                    .font(.title)
                    .controlSize(.extraLarge)
                .foregroundColor(.black).padding(.top, 70)
                
                Button("-") {
                    scale -= 0.3
                }.buttonStyle(.borderedProminent)
                    .tint(.red)
                    .font(.title)
                    .controlSize(.extraLarge)
                    .foregroundColor(.black).padding([.top, .leading], 70)
            }
        }
    }
}

#Preview {
    CookieClicker()
}
