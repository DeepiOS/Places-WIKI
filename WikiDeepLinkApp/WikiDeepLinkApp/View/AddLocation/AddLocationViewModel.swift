//
//  AddLocationViewModel.swift
//  WikiDeepLinkApp
//
//  Created by Deepak Panigrahi on 21/09/2024.
//

import Foundation
import SwiftUI

extension AddLocationView {
    final class ViewModel: ObservableObject {
        let localDataStorage: LocalDataStoring
        @Binding var cityList: [String]
        @Binding var isPresented: Bool
        @Published var inputText: String = ""
        @Published var showInformationMessage: Bool = false

        init(
            cityList: Binding<[String]>,
            isPresented: Binding<Bool>,
            localDataStorage: LocalDataStoring
        ) {
            self.localDataStorage = localDataStorage
            _cityList = cityList
            _isPresented = isPresented
        }

        func handleAction(_ action: Action) {
            switch action {
            case .save:
                guard !inputText.isEmpty else { return }
                // Check if the input city is already present in the list
                guard !cityList.contains(where: { $0.lowercased() == inputText.lowercased() }) else {
                    showInformationMessage = true
                    return
                }
                localDataStorage.store(data: inputText)
                cityList.append(inputText)
                isPresented = false
            }
        }
    }
}

extension AddLocationView.ViewModel {
    enum Action {
        case save
    }
}
