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

//TODO: AVCaptureDevice is key to manual control of exposure; see Configuring Exposure Manually
class CameraSession: UIViewController {
    
    let captureSession = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    var frontCameraDeviceInput: AVCaptureDeviceInput?
    var backCameraDeviceInput: AVCaptureDeviceInput?
    var photoDelegate = CapturePhotoDelegate()
    private let sessionQueue = DispatchQueue(label: "session queue")
    var previewView = CameraPreview()
    
    func configureSession(videoDevice: AVCaptureDevice) {
        captureSession.beginConfiguration()
        
        // Configure inputs
        guard
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
            captureSession.canAddInput(videoDeviceInput)
            else { return }
        captureSession.addInput(videoDeviceInput)
        print(videoDevice)
        print("Inputs configured")
        
        // Configure outputs
        guard captureSession.canAddOutput(photoOutput) else {
            print("Could not add photo output to session")
            return
        }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        print("Outputs configured")
        
        // End and committ configuration
        captureSession.commitConfiguration()
        
        // Connect session to preview
        previewView = CameraPreview()
        self.previewView.videoPreviewLayer.session = self.captureSession
        print("Preview connected")
        
        // Run the session
        sessionQueue.async {
            self.captureSession.startRunning()
        }
        print("Session running")
        
    }
    
    func configurePhotoSettings(isFlashOn: Bool) -> AVCapturePhotoSettings {
        var photoSettings = AVCapturePhotoSettings()
        
        if self.photoOutput.availablePhotoCodecTypes.contains(AVVideoCodecType.hevc) {
            photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
            print(photoSettings)
        }
        
        photoSettings.flashMode = isFlashOn ? AVCaptureDevice.FlashMode.on : AVCaptureDevice.FlashMode.off
        
        print("photoSettings configured")
        return photoSettings
        
    }
    
    func capturePhoto(photoSettings: AVCapturePhotoSettings) {
        print(previewView)
        
        sessionQueue.async {
            print("Taking photo")
            self.photoDelegate = CapturePhotoDelegate()
            
            print("sessionQueue.async running capturePhoto")
            self.photoOutput.capturePhoto(with: photoSettings, delegate: self.photoDelegate)
        }
        
    }
    
    func switchCamera(frontOrBack: Bool) {
        print("Switching camera")
        let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)

        frontCameraDeviceInput = try? AVCaptureDeviceInput(device: frontCamera!)
        backCameraDeviceInput = try? AVCaptureDeviceInput(device: backCamera!)
        
        captureSession.beginConfiguration()
        
        if frontOrBack {
            print("Switching to front camera")
            captureSession.removeInput(captureSession.inputs.first!)
            captureSession.addInput(frontCameraDeviceInput!)
        } else if !frontOrBack {
            print("Switching to back camera")
            captureSession.removeInput(captureSession.inputs.first!)
            captureSession.addInput(backCameraDeviceInput!)
        }
        
        captureSession.commitConfiguration()
    }
    
}
