//
//  PhotoLibraryDisplay.swift
//  Manual Photographer
//
//  Created by Maksim on 12/25/23.
//

import SwiftUI
import Photos
import PhotosUI

// Takes data from PhotoLibrary and turns it into a view
struct PhotoLibraryDisplay: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    //var photos = PhotoLibrary()
    
    var body: some View {
        
        LazyVGrid(columns: columns) {
            ForEach(PhotoLibrary.getPhotos()) { photo in
                Image(uiImage: photo.value)
            }
        }
    }
}

//#Preview {
//    PhotoLibraryDisplay()
//}
