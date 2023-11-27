//
//  ChickenClicker.swift
//
//  Created by Maksim on 10/27/23.
//

import SwiftUI

struct ChickenClicker: View {
    @State private var counter: Int = 0
    
    var body: some View {
        VStack {
            VStack {
                ChickenFedora()
                Text("Chicken Clicker").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    
            }
            .padding()
            
            VStack {
                Text("\(counter)")
                    .padding()
                    .border(Color.gray, width: 2)
                    .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                Button("Increment") {
                    self.counter += 1
                }.buttonStyle(.borderedProminent)
                    .tint(.red)
                    .font(.title)
                    .controlSize(.extraLarge)
                    .foregroundColor(.black)
            }
        }
    }
}
