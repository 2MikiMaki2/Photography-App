//
//  PhotoLibrary.swift
//  Manual Photographer
//
//  Created by Maksim on 12/12/23.
//

import SwiftUI
import UIKit
import Foundation
import AVFoundation
import Photos
import PhotosUI

// Reads data from album in camera roll
class PhotoLibrary {
    static var albumLocation = ""
    static var album: [AlbumPhoto] = []
    static let albumDidUpdateNotification = Notification.Name("PhotoLibraryAlbumDidUpdate")

    public struct AlbumPhoto: Identifiable {
        let id = UUID()
        let value: UIImage       // Thumbnail (100x100)
        let asset: PHAsset       // Reference for full-res loading
    }
    
    static func getPhotos() async -> [AlbumPhoto] {
        await checkAlbumAsync()
        updateAlbum()

        return album
    }
    
    static func getAlbumLocation() -> String {
        return albumLocation
    }
    
    static func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
            print(info as Any)
        })
        
        return thumbnail
    }

    static func getFullResolutionImage(asset: PHAsset) async -> UIImage? {
        return await withCheckedContinuation { continuation in
            let manager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.isSynchronous = false
            options.deliveryMode = .highQualityFormat
            options.isNetworkAccessAllowed = true  // For iCloud photos

            manager.requestImage(
                for: asset,
                targetSize: PHImageManagerMaximumSize,
                contentMode: .aspectFit,
                options: options
            ) { (image, info) in
                continuation.resume(returning: image)
            }
        }
    }

    static func checkAlbumAsync() async {
        if (albumLocation == "") {
            // Check if album already exists
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", "Manual Photographer")
            let existingAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

            if let existingAlbum = existingAlbums.firstObject {
                albumLocation = existingAlbum.localIdentifier
                print("Found existing Manual Photographer album: \(albumLocation)")
            } else {
                print("Making album in PhotoLibrary")
                do {
                    try await PHPhotoLibrary.shared().performChanges {
                        let assetRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: "Manual Photographer")
                        let assetPlaceholder = assetRequest.placeholderForCreatedAssetCollection
                        albumLocation += assetPlaceholder.localIdentifier
                        print("localIdentifier after making album: \(assetPlaceholder.localIdentifier)")
                        print("albumLocation in checkAlbum(): \(albumLocation)")
                    }
                    print("Album created successfully")
                } catch {
                    print("Error making album: \(error.localizedDescription)")
                }
            }
        } else {
            print("albumLocation already exists")
        }
    }

    static func checkAssetCollection() -> Bool {
        let assetCollection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumLocation], options: nil).firstObject
        if (assetCollection != nil) {
            let fetchResult = PHAsset.fetchAssets(in: assetCollection!, options: nil)
            print("in checkAssetCollection fetchResult.count: \(fetchResult.count)")
            if fetchResult.count > 0 {
                print("checkAssetCollection returned true")
                return true
            }
        }
        
        print("checkAssetCollection returned false")
        return false
    }
    
    static func updateAlbum() {
        if checkAssetCollection() {
            album = []
            let assetCollection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumLocation], options: nil).firstObject
            if (assetCollection != nil) {
                let fetchResult = PHAsset.fetchAssets(in: assetCollection!, options: nil)
                print("in updateAlbum fetchResult.count: \(fetchResult.count)")
                for index in 0...(fetchResult.count - 1) {
                    print("Index in updateAlbum: \(index)")
                    let asset = fetchResult.object(at: index)
                    let photo = AlbumPhoto(value: getAssetThumbnail(asset: asset), asset: asset)
                    album.append(photo)
                    print("Added photo to var album")
                    print("Size of album immediately  after album.append: \(album.count)")
                }
            }

            // Post notification on main thread
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: albumDidUpdateNotification, object: nil)
            }
        }
    }
    
}

//#Preview {
//    PhotoLibrary()
//}
