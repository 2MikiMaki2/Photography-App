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
    var session: CameraSession
    
    func makeUIView(context: Context) -> CameraPreview {
        
        session.configureSession()
        let view = session.previewView
        
        return view
    }
    
    func updateUIView(_ uiView: CameraPreview, context: Context) {
        // Leave empty, unnecessary
    }
    
}
