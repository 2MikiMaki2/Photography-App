//
//  CameraSession.swift
//  Manual Photographer
//
//  Created by Maksim on 11/21/23.
//

import Foundation
import AVFoundation
import UIKit
import Photos

class CameraSession: UIViewController {
    
    let captureSession = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    var previewView = CameraPreview()
    
    func configureSession() {
        captureSession.beginConfiguration()
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                  for: .video, position: .unspecified)
        
        // Configure inputs
        guard
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
            captureSession.canAddInput(videoDeviceInput)
            else { return }
        captureSession.addInput(videoDeviceInput)
        print("Inputs configured")
        
        // Configure outputs
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        print("Outputs configured")
        
        // End and committ configuration
        captureSession.commitConfiguration()
        
        // Connect session to preview
        //previewView.session = captureSession
        self.previewView.videoPreviewLayer.session = self.captureSession
        print("Preview set")
        
        // Run the session
        self.captureSession.startRunning()
        print("Session running")
        
    }
    
    func capturePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        let photoDelegate = CapturePhotoDelegate()
        
        self.photoOutput.capturePhoto(with: photoSettings, delegate: photoDelegate)
    }
    
}
