//
//  CameraUI.swift
//  Manual Photographer
//
//  Created by Maksim on 11/29/23.
//

import Foundation
import UIKit
import SwiftUI

struct CameraUI: View {
    let session = CameraSession()
    @State private var animate = false
    
    var body: some View {
        VStack {
            RepresentedCamPreview(session: session)
            
            Button {
                animate.toggle()
                //session.capturePhoto()
            } label: {
                Image(systemName: "camera.circle.fill")
            }.symbolRenderingMode(.hierarchical).symbolEffect(.bounce, value: animate).font(.largeTitle).padding(.bottom, 60)
        }
    }
}
