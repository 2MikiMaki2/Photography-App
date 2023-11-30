//
//  ContentView.swift
//  Manual Photographer
//
//  Created by Maksim on 10/24/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ChickenClicker().tabItem { Image(systemName: "photo.stack")
            }
            
            CameraUI().tabItem {
                Image(systemName: "camera")
                }
            
            CookieClicker().tabItem {
                Image(systemName: "person")
            }
        }
    }
}

#Preview {
    ContentView()
}
