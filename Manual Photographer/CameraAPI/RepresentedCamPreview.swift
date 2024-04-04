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
        
        session.configureSession(exposureTime: CMTimeMake(value: 0, timescale: 0))
        
        let view = session.previewView
        
        return view
    }
    
    func updateUIView(_ uiView: CameraPreview, context: Context) {
        //print("Updating view, frontOrBack is " + String(frontOrBack))
    }
    
}
