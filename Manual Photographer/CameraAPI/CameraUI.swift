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
    @State private var animateLense = false
    
    @GestureState private var magnifyBy = 1.0


    var magnification: some Gesture {
        MagnifyGesture()
            .updating($magnifyBy) { value, gestureState, transaction in
                gestureState = value.magnification
            }
            .onChanged() { value in
                session.configureZoom(magnification: value.magnification)
            }
//            .onEnded() { value in
//                session.currentCameraDevice!.cancelVideoZoomRamp()
//            }
        }
    
//    @State private var exposureDial: RotaryDial = RotaryDial<CMTime>(valueSet: [CMTimeMake(value: 1, timescale: 8000), CMTimeMake(value: 1, timescale: 4000), CMTimeMake(value: 1, timescale: 2000), CMTimeMake(value: 1, timescale: 1000), CMTimeMake(value: 1, timescale: 500), CMTimeMake(value: 1, timescale: 250), CMTimeMake(value: 1, timescale: 1)], value: CMTimeMake(value: 1, timescale: 1))
    
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
                    if (animateDevice) {
                        session.switchCamera(newDevice: AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)!)
                    } else {
                        session.switchCamera(newDevice: AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)!)
                    }
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath.camera").symbolRenderingMode(.hierarchical).symbolEffect(.bounce.down, value: animateDevice).font(.largeTitle)
                }.foregroundStyle(.white)
                
//                Button {
//                    session.configureExposureTime(exposureTime: exposureDial.value)
//                    //session.configureSession(exposureTime: exposureDial.getValue())
//                } label: {
//                    Image(systemName: "sun.max").font(.largeTitle)
//                }.foregroundStyle(.white)
            }
            
            HStack {
                Button {
                    session.switchCamera(newDevice: AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back)!)
                } label: {
                    Image(systemName: "camera.macro.circle").symbolRenderingMode(.hierarchical).symbolEffect(.bounce, value: animateLense).font(.largeTitle)
                }.foregroundStyle(.white)
                
                Button {
                    session.switchCamera(newDevice: AVCaptureDevice.default(.builtInTelephotoCamera, for: .video, position: .back)!)
                } label: {
                    Image(systemName: "plus.viewfinder").symbolRenderingMode(.hierarchical).symbolEffect(.bounce, value: animateLense).font(.largeTitle)
                }.foregroundStyle(.white)
                
                Button {
                    session.switchCamera(newDevice: AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)!)
                } label: {
                    Image(systemName: "camera.circle").symbolRenderingMode(.hierarchical).symbolEffect(.bounce, value: animateLense).font(.largeTitle)
                }.foregroundStyle(.white)
            }
            
            ZStack {
                RepresentedCamPreview(frontOrBack: $animateDevice, session: session)
                    .gesture(magnification)
                
                //exposureDial.offset(x: 0.0, y: 300.0)
            }
            
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
