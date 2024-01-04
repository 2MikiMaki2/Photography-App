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
    @State private var animateCapture = false
    @State private var animateFlash = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    animateFlash.toggle()
                } label: {
                    Image(systemName: animateFlash ? "bolt.fill" : "bolt.slash.fill").contentTransition(.symbolEffect(.replace.downUp)).font(.largeTitle)
                }
            }
            
            RepresentedCamPreview(session: session)
            
            Button {
                let captureSettings = session.configurePhotoSettings(isFlashOn: animateFlash)
                session.capturePhoto(photoSettings: captureSettings)
                animateCapture.toggle()
            } label: {
                Image(systemName: "camera.circle.fill").symbolRenderingMode(.monochrome).symbolEffect(.bounce, value: animateCapture).font(.largeTitle).padding(.bottom, 60)
            }
        }
    }
}
