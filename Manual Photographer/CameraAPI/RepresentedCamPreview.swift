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

        // Configure view to expand and fill its container
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Configure preview layer to fill the view
        view.videoPreviewLayer.videoGravity = .resizeAspectFill

        return view
    }
    
    func updateUIView(_ uiView: CameraPreview, context: Context) {
        //print("Updating view, frontOrBack is " + String(frontOrBack))
    }
    
}
