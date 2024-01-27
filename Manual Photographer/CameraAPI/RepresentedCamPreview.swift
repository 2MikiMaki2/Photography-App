//
//  RepresentedCamPreview.swift
//  Manual Photographer
//
//  Created by Maksim on 11/26/23.
//

import Foundation
import UIKit
import SwiftUI
import AVFoundation

struct RepresentedCamPreview: UIViewRepresentable {
    typealias UIViewType = CameraPreview
    @Binding var frontOrBack: Bool
    var session: CameraSession
    
    func makeUIView(context: Context) -> CameraPreview {
        
        
        session.configureSession(videoDevice: AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified)!)
        let view = session.previewView
        
        return view
    }
    
    func updateUIView(_ uiView: CameraPreview, context: Context) {
        //TODO: Figure out how to use this to change device?
//        print("Updating view, fronOrBack is " + String(frontOrBack))
//        
//        if frontOrBack {
//            session.configureSession(videoDevice: AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)!)
//        } else {
//            session.configureSession(videoDevice: AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)!)
//        }
        
        
    }
    
}
