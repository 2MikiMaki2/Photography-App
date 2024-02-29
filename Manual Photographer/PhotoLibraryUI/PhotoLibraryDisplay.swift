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
    @Binding var photos: [PhotoLibrary.AlbumPhoto]
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(photos) { photo in
                        Image(uiImage: photo.value)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .clipped()
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
        }
    }
}

//#Preview {
//    PhotoLibraryDisplay()
//}
