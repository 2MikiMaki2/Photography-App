//
//  RepresentedCamPreview.swift
//  Manual Photographer
//
//  Created by Maksim on 11/26/23.
//

import Foundation
import UIKit
import SwiftUI

struct RepresentedCamPreview: UIViewRepresentable {
    typealias UIViewType = CameraPreview
    
    func makeUIView(context: Context) -> CameraPreview {
        //let view = CameraPreview()
        
        let session = CameraSession()
        session.configureSession()
        let view = session.previewView
        
        return view
    }
    
    func updateUIView(_ uiView: CameraPreview, context: Context) {
        // Leave empty, unnecessary
    }
    
}
