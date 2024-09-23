//
//  LocationListView.swift
//  WikiDeepLinkApp
//
//  Created by Deepak Panigrahi on 20/09/2024.
//

import SwiftUI

struct LocationListView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack {
            locationListView(viewModel.cityList)
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .accessibilityLabel(Text(AppConstants.loading))
                    .accessibilityHint(Text(AppConstants.loadingSavedLocationMessage))
            }
        }
        .alert(isPresented: $viewModel.showErrorMessage) {
            Alert(
                title: Text(AppConstants.fetchLocationErrorTitle),
                message: Text(AppConstants.fetchLocationErrorMessage),
                dismissButton: .default(Text(AppConstants.alertActionBtnTitle))
            )
        }
        .toolbar {
            Button {
                viewModel.handleAction(.addLocation)
            } label: {
                Text(" ✚ ")
                    .foregroundStyle(Color.textPrimary)
                    .font(.title)
            }
            .accessibilityLabel(Text(AppConstants.addNewPlace))
            .accessibilityHint(Text(AppConstants.addNewPlaceMessage))
        }
        .sheet(isPresented: $viewModel.showAddLocation) {
            AddLocationView(
                viewModel: .init(
                    cityList: $viewModel.cityList,
                    isPresented: $viewModel.showAddLocation,
                    localDataStorage: viewModel.localDataStorage
                )
            )
        }
        .navigationTitle(AppConstants.locationListTitle)
    }

    //"This screen has list of places which you can click and see the location on the Wikipedia app's map"

    @ViewBuilder
    func locationListView(_ places: [String]) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(places, id: \.self) { name in
                    rowView(name)
                }
            }
        }
        .refreshable {
            viewModel.handleAction(.refresh)
        }
    }

    @ViewBuilder
    func rowView(_ name: String) -> some View {
        VStack {
            HStack {
                Text(name)
                    .foregroundStyle(Color.textPrimary)
                    .font(.title3)
                    .padding()
                Spacer()
            }
            Color.white
                .frame(height: 1.0)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.handleAction(.locationTapped(name))
        }
        .background {
            Color.background
        }
    }
}

#Preview {
    LocationListView(
        viewModel: .init(
            networkService: DefaultNetworkService(),
            deeplinkBuilder: WikiDeepLinkBuilder(), 
            localDataStorage: LocalDataStorage()
        )
    )
}
