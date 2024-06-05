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
    
    //SO MANY!!! Is there a way to reduce?
    @State private var animateCapture = false
    @State private var animateFlash = false
    @State private var animateDevice = false
    @State private var animateLense = false
    @State private var animateSlider = false
    @State private var focalLength = 0.5
    @State private var isEditingFocus = false
    
    @GestureState private var magnifyBy = 1.0
    @GestureState private var interestPoint = CGPoint()

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
    
    var focusTap: some Gesture {
        SpatialTapGesture(count: 1)
            .updating($interestPoint) { value, gestureState, transaction in
                gestureState = value.location
            }
            .onEnded() { event in
                session.configureFocusPoint(focusPoint: event.location)
            }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    isEditingFocus.toggle()
                } label: {
                    Image(systemName: "slider.horizontal.below.rectangle").symbolRenderingMode(.hierarchical).symbolEffect(.bounce.down, value: animateSlider).font(.largeTitle)
                }.foregroundStyle(.white)
                
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
                    .gesture(magnification).gesture(focusTap)
                
                //exposureDial.offset(x: 0.0, y: 300.0)
            }
            
            VStack {
                HStack {
                    Button {
                        animateCapture.toggle()
                        let captureSettings = session.configurePhotoSettings(isFlashOn: animateFlash)
                        session.capturePhoto(photoSettings: captureSettings)
                    } label: {
                        Image(systemName: "camera.shutter.button").symbolRenderingMode(.hierarchical).symbolEffect(.bounce, value: animateCapture).font(.largeTitle).padding(.bottom, 60)
                    }.foregroundStyle(.white)
                }.offset(x: 0.0, y: 30.0)
                
                HStack {
                    Text("\(focalLength)")
                        
                    Slider (
                        value: $focalLength,
                        in: 0.0...1.0) { editing in
                            session.configureLensPostion(lensPosition: Float(focalLength))
                        }
                }.opacity(isEditingFocus ? 0.0 : 1.0)
            }
        }
    }
}
