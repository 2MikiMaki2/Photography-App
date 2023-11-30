//
//  CameraPreview.swift
//  Manual Photographer
//
//  Created by Maksim on 11/21/23.
//

import Foundation
import SwiftUI
import AVFoundation
import UIKit

class CameraPreview: UIView {
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
        
    /// Convenience wrapper to get layer as its statically known type.
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    
    
}
