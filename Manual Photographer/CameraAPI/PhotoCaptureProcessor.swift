//
//  CapturePhotoDelegate.swift
//  Manual Photographer
//
//  Created by Maksim on 11/29/23.
//

import Foundation
import Photos

class CapturePhotoDelegate: NSObject {
    
    let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    
    override init() {
        super.init()
        print("New delegate")
    }
    
    func isPhotoLibraryReadWriteAccessGranted() async -> Bool {
            //let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            
            var isAuthorized = (status == .authorized)
            
            print("Requesting access to library")
            if status == .notDetermined {
                isAuthorized = await PHPhotoLibrary.requestAuthorization(for: .readWrite) == .authorized
            }
            
            return isAuthorized
    }
    
}

extension CapturePhotoDelegate: AVCapturePhotoCaptureDelegate {
    
    // Monitors capture progress
    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        print("willBeginCaptureFor")
        print(resolvedSettings)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        print("willCapturePhotoFor")
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        print("didCapturePhotoFor")
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        print("didFinishCaptureFor")
    }
    
    // Receives capture results
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("didFinishProcessingPhoto")
        if let error {
            print("Error processing photo: \(error.localizedDescription)")
            return
        }
        
        Task {
            await savePhotoToLibrary(photo: photo)
        }
    }

    func savePhotoToLibrary(photo: AVCapturePhoto) async {
        print("Attempting to save photo")
        guard await isPhotoLibraryReadWriteAccessGranted() else { return }
        
        if let photoData = photo.fileDataRepresentation() {
            PHPhotoLibrary.shared().performChanges {
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: photoData, options: nil)
            } completionHandler: { success, error in
                if let error {
                    print("Error saving photo: \(error.localizedDescription)")
                    return
                }
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishRecordingLivePhotoMovieForEventualFileAt outputFileURL: URL, resolvedSettings: AVCaptureResolvedPhotoSettings) {
        print("didFinishRecordingLivePhotoMovie")
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingLivePhotoToMovieFileAt outputFileURL: URL, duration: CMTime, photoDisplayTime: CMTime, resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        print("didFinishProcessingLivePhotoMovie")
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCapturingDeferredPhotoProxy deferredPhotoProxy: AVCaptureDeferredPhotoProxy?, error: Error?) {
        print("didFinishCapturingDefferredPhotoProxy")
    }
    
}

