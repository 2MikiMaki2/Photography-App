//
//  CameraUI.swift
//  Manual Photographer
//
//  Created by Maksim on 11/29/23.
//

import Foundation
import UIKit
import SwiftUI
import AVFoundation

//TODO: Figure out how to scroll (unlock gesture gates)
struct CameraUI: View {
    let session = CameraSession()
    
    @State private var animateCapture = false
    @State private var animateFlash = false
    @State private var animateDevice = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    animateFlash.toggle()
                } label: {
                    Image(systemName: animateFlash ? "bolt.fill" : "bolt.slash.fill").symbolRenderingMode(.hierarchical).contentTransition(.symbolEffect(.replace.downUp)).font(.largeTitle)
                }.foregroundStyle(.white)
                
                //TODO: Press to toggle camera device between .front and .back
                Button {
                    animateDevice.toggle()
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath").symbolRenderingMode(.hierarchical).symbolEffect(.bounce.down, value: animateDevice).font(.largeTitle)
                }.foregroundStyle(.white)
            }
            
            RepresentedCamPreview(frontOrBack: $animateDevice, session: session)
            
            HStack {
                Button {
                    animateCapture.toggle()
                    let captureSettings = session.configurePhotoSettings(isFlashOn: animateFlash)
                    session.capturePhoto(photoSettings: captureSettings)
                } label: {
                    Image(systemName: "camera.shutter.button").symbolRenderingMode(.hierarchical).symbolEffect(.bounce, value: animateCapture).font(.largeTitle).padding(.bottom, 60)
                }.foregroundStyle(.white)
            }
        }
    }
}
