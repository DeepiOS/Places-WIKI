# Places-WIKI

## General Info
This repository includes two application.
* Modified Wikipedia application which the support if deep-link action.
* Places iOS app by using which user can add places see those on Wikipedia via a deep-link.


## Instructions
Please follow below septs to use these apps:
* Download/Clone the repository.
* Open wikipedia-ios-modified folder and install the app in the device.
* Open WikiDeepLinkApp(Places) folder and install the app in the device.
* Now you can tap on the location names visible on Places app to open open WIKI map via deep-link. 
* Enjoy🙂.

## App Architecture && Technologies

###Places App:
* The Architecture followed in the app is MVVM.
* There are builder pattern used to process and create ViewModel.
* The whole app is built using SwiftUI + Combine using protocol oriented programming.
* Plist is being used to save user data.
* XCTest framework is used to extensively cover all the parts of the codebase with unit-tests.

###Wikipedia App:
* There no architectural change in this app.

## App Modules
###Places App:
The app consist of two screens.
    * Locations list screen
    * Add new location screen.
Locations list screen:
* This screen has two kinds of locations.
 - Location send by server.
 - Locally saved location by user using Add Location screen.
* There is a add button on the top right corner to open Add Location screen. 
Add new location screen:
* This screen has a input filed to take the user typed location.
* A save button to store it locally.
* There are couple of validation for empty and duplicate.

## Dependency
None

## Xcode
15.4

## TODO
- [ ] Accessibility is one thing which needs to be taken care as this app has minimal implementation of it.
- [ ] UI testing.
- [ ] User input location validation.
