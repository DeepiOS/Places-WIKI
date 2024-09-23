//
//  AddLocationView.swift
//  WikiDeepLinkApp
//
//  Created by Deepak Panigrahi on 21/09/2024.
//

import SwiftUI

struct AddLocationView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        NavigationView {
            VStack {
                TextField(AppConstants.addLocationPlaceholder, text: $viewModel.inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Spacer()

                // Button to save the new string
                Button(action: {
                    viewModel.handleAction(.save)
                }) {
                    Text(AppConstants.addLocationSave)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .accessibilityLabel(Text(AppConstants.addLocationSave))
                .accessibilityHint(Text(AppConstants.pressToSaveMessage))
                .opacity(viewModel.inputText.isEmpty ? 0.5 : 1.0)
                .disabled(viewModel.inputText.isEmpty)
                .padding()
            }
            .alert(isPresented: $viewModel.showInformationMessage) {
                Alert(
                    title: Text(AppConstants.addLocationInfoTitle),
                    message: Text(AppConstants.addLocationInfoMessage),
                    dismissButton: .default(Text(AppConstants.alertActionBtnTitle))
                )
            }
            .navigationTitle(AppConstants.addLocationTitle)
        }
    }
}

