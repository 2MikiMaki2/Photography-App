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
    var currentCameraDevice: AVCaptureDevice?
    var currentCameraDeviceInput: AVCaptureDeviceInput?
    var photoDelegate = CapturePhotoDelegate()
    private let sessionQueue = DispatchQueue(label: "session queue")
    var previewView = CameraPreview()
    
    func configureSession(exposureTime: CMTime) {
        print("Configuring session")
        captureSession.beginConfiguration()
        
        currentCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        //configureExposureTime(exposureTime: exposureTime)
        
        // Configure inputs
        guard
        let videoDeviceInput = try? AVCaptureDeviceInput(device: currentCameraDevice!),
            captureSession.canAddInput(videoDeviceInput)
            else { return }
        captureSession.addInput(videoDeviceInput)
        print(currentCameraDevice!)
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
            //self.configureExposureTime(exposureTime: exposureTime)
            
            print("sessionQueue.async running capturePhoto")
            //print("Exposure time: \(exposureTime)")
            self.photoOutput.capturePhoto(with: photoSettings, delegate: self.photoDelegate)
        }
        
    }
    
    func configureExposureTime(exposureTime: CMTime) {
        do {
            try currentCameraDevice?.lockForConfiguration()
        } catch {
            print("Error occurred locking device for exposure configuration")
        }
        
        if (exposureTime >= (currentCameraDevice?.activeFormat.minExposureDuration)! && exposureTime <= (currentCameraDevice?.activeFormat.maxExposureDuration)!) {
            print("exposureTime within limits")
            currentCameraDevice?.setExposureModeCustom(duration: exposureTime, iso: (currentCameraDevice?.activeFormat.minISO)!)
        }
        
        currentCameraDevice?.unlockForConfiguration()
    }
    
    func configureZoom(magnification: CGFloat) {
        do {
            try currentCameraDevice?.lockForConfiguration()
        } catch {
            print("Error occurred locking device for zoom configuration")
        }
        
        if (magnification <= currentCameraDevice!.activeFormat.videoMaxZoomFactor) {
            if (magnification > 1) {
                currentCameraDevice!.ramp(toVideoZoomFactor: magnification, withRate: 10.0)
            } else {
                currentCameraDevice!.ramp(toVideoZoomFactor: 1.0, withRate: 10.0)
            }
        }
        
        currentCameraDevice!.unlockForConfiguration()
    }
    
    //TODO: Make switchTo that takes camera device and switches to it
    func switchCamera(newDevice: AVCaptureDevice) {
        print("Switching camera")

        currentCameraDeviceInput = try? AVCaptureDeviceInput(device: newDevice)
        
        captureSession.beginConfiguration()
        
        captureSession.removeInput(captureSession.inputs.first!)
        captureSession.addInput(currentCameraDeviceInput!)
        
        captureSession.commitConfiguration()
    }
    
}
