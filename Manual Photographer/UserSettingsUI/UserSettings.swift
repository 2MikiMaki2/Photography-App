//
//  UserSettings.swift
//  Manual Photographer
//
//  Created by Maksim on 1/12/24.
//

import SwiftUI
import AVFoundation
import Photos

struct UserSettings: View {
    var body: some View {
        UserPermissions()
    }
    
    static func checkCameraPermission() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // Already authorized
            print("Camera access already granted")
            return true
        case .notDetermined, .denied, .restricted:
            // Request permission
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if granted {
                print("Camera access granted")
                return true
            } else {
                print("Camera access denied")
                return false
            }
        @unknown default:
            break
        }
        
        return false
    }

    static func checkReadWritePermission() async -> Bool {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized, .limited:
            // Access already granted
            print("Read-write already granted")
            return true
        case .notDetermined, .denied, .restricted:
            //Request permission if not yet determined
            let granted = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            if granted == .authorized {
                // Access granted
                print("Read-write granted")
                return true;
            } else {
                // Access denied
                print("Read-write denied")
                return false;
            }
        @unknown default:
            break
        }
        
        return false;
    }
}

//#Preview {
//    UserSettings()
//}
