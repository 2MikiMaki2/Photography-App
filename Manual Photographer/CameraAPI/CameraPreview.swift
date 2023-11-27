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
//    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
//        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
//            fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation.")
//        }
//        return layer
//    }
//    
//    var session: AVCaptureSession? {
//        get {
//            return videoPreviewLayer.session
//        }
//        set {
//            videoPreviewLayer.session = newValue
//        }
//    }
//    
//    override class var layerClass: AnyClass {
//        return AVCaptureVideoPreviewLayer.self
//    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
        
    /// Convenience wrapper to get layer as its statically known type.
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
}
