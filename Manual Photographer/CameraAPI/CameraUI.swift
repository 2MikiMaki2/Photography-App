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

struct CameraUI: View {
    let session = CameraSession()
    
    @State private var animateCapture = false
    @State private var animateFlash = false
    @State private var animateDevice = false
    
    @State private var exposureDial = RotaryDial<CMTime>(valueSet: [CMTimeMake(value: 1, timescale: 8000), CMTimeMake(value: 1, timescale: 4000), CMTimeMake(value: 1, timescale: 2000), CMTimeMake(value: 1, timescale: 1000), CMTimeMake(value: 1, timescale: 500), CMTimeMake(value: 1, timescale: 250), CMTimeMake(value: 1, timescale: 1)], value: CMTimeMake(value: 1, timescale: 1))
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    animateFlash.toggle()
                } label: {
                    Image(systemName: animateFlash ? "bolt.fill" : "bolt.slash.fill").symbolRenderingMode(.hierarchical).contentTransition(.symbolEffect(.replace.downUp)).font(.largeTitle)
                }.foregroundStyle(.white)
                
                Button {
                    animateDevice.toggle()
                    print("animateDevice is: \(animateDevice)")
                    session.switchCamera(frontOrBack: animateDevice)
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath.camera").symbolRenderingMode(.hierarchical).symbolEffect(.bounce.down, value: animateDevice).font(.largeTitle)
                }.foregroundStyle(.white)
                
                Button {
                    session.configureExposureTime(exposureTime: exposureDial.getValue())
                    //session.configureSession(exposureTime: exposureDial.getValue())
                } label: {
                    Image(systemName: "sun.max").font(.largeTitle)
                }.foregroundStyle(.white)
            }
            
            ZStack {
                RepresentedCamPreview(frontOrBack: $animateDevice, session: session)
                
                exposureDial.offset(x: 0.0, y: 50.0)
            }
            
            HStack {
                Button {
                    animateCapture.toggle()
                    let captureSettings = session.configurePhotoSettings(isFlashOn: animateFlash)
                    //TODO: Why does exposureDial.getValue() not return right thing?
                    session.capturePhoto(photoSettings: captureSettings, exposureTime: exposureDial.getValue())
                } label: {
                    Image(systemName: "camera.shutter.button").symbolRenderingMode(.hierarchical).symbolEffect(.bounce, value: animateCapture).font(.largeTitle).padding(.bottom, 60)
                }.foregroundStyle(.white)
            }
        }
    }
}
