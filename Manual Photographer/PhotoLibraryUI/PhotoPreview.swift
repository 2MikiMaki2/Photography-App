//
//  PhotoPreview.swift
//  Manual Photographer
//
//  Created by Maksim on 12/12/23.
//

import SwiftUI
import Photos

struct PhotoPreview: View {
    let photo: PhotoLibrary.AlbumPhoto
    @Environment(\.dismiss) var dismiss
    @State private var fullResImage: UIImage?
    @State private var isLoading = true
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()

                if isLoading {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                        Text("Loading...")
                            .foregroundColor(.white)
                            .padding(.top)
                    }
                } else if let image = fullResImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(scale)
                        .gesture(
                            MagnifyGesture()
                                .onChanged { value in
                                    scale = lastScale * value.magnification
                                }
                                .onEnded { value in
                                    lastScale = scale
                                    if scale < 1.0 {
                                        withAnimation {
                                            scale = 1.0
                                            lastScale = 1.0
                                        }
                                    }
                                }
                        )
                } else {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        Text("Failed to load image")
                            .foregroundColor(.white)
                            .padding(.top)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                    .foregroundColor(.white)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .task {
            fullResImage = await PhotoLibrary.getFullResolutionImage(asset: photo.asset)
            isLoading = false
        }
    }
}

//#Preview {
//    PhotoPreview()
//}
