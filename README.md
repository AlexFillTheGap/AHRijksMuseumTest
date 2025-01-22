# AH Rijks Museum App test
This is a test for AH selection process from Alejandro Fernández Ruiz.

# Rijks Museum#
[![N|Solid](https://www.rijksmuseum.nl/assets/e1991007-a928-4a3e-895a-fff45844a8d0?w=1920&h=984&fx=1920&fy=1080&format=webp&c=61ed0e055644c86cf8ca68ca5f93b85a6a3b6a9e47babd17b06ecfbdabfe2387)](https://www.rijksmuseum.nl/en)

### What is this repository for?
* This is a test for AH selection process from Alejandro Fernández Ruiz.
* Project has been written on XCode 16.2 and Swift 6 

#### Configuration
* The project should be stand-alone and running on a simulator must be enough.

#### Dependencies
* I have used SwiftLint as code linter, installed on the project using Swift Package Manager

#### How to run tests
* The unit tests have been developed with the XCTest 
* Comments about the tests: 
    *  I have basically focused on the Interactors and Presenters tests.
This is because these are the classes that should contain the business logic and above all the ones that should be accessible for unit testing.
    * Currently the coverage is around 50%.

#### Dessign pattern.
This project uses the VIP (View-Interactor-Presenter) design pattern. The main idea is that each scene of the application is developed by means of three specific classes, allowing all its functionalities to be implemented in an organised way:
    - V (View): manages everything related to the user interface, including the visual components and their layout. It is responsible for displaying information and responding to user interactions.
    - I (Interactor): Handles the business logic of the scene. It communicates with other layers, such as the service layer or the data layer, to obtain information and sends it to the presenter.
    - P (Presenter): Receives the data processed by the Interactor, transforms it as necessary and delivers it to the view for rendering. Any changes to the user interface must first go through the presenter.

This pattern ensures a clear separation of responsibilities, facilitating code maintenance and scalability.

### App use
The app consists of two scenes.

The initial scene is where you can access the collection. The downloading of artworks is done in steps.
Initially the first page of artworks is loaded, if we scroll through the collection view, we can reach the end of the first page, getting a new request for the next page, which will be added to the list that we already had, and so on for the following scrolls.
With each scroll a new section is created, with its header that should tell us to which page the list of images belongs. We can see on the screen with brown background and Section number text.

In each cell we see an image related to the artwork in question with the title on a translucent view, the idea is to show the white text on any background (light or dark) and to make it legible.

By tapping on any of the cells, we can go to a different screen, where we see the image of the artwork, as well as the title in the navigation bar, the author and the description.
If the description is too long, the screen should scroll the text keeping the image still, because I think the focus should be on the image of the artwork.

I have included a cache to store all the downloaded images, making faster the table reloading, anytime the app needs to access a remote url image, first checks if is contained on the cache, if not it start async download of it.

### Error handling
I have included Networking Errors to to raise them through the asynchronous throw methods, if an error occurs during execution the ArtService handle it and throw an updated version of it with messages to inform user about what is happening

the Interactor captures it, to proceed to the corresponding error Response, allowing the user to be informed by means of an AlertView.

### How to improve this project
If I have extra time for this project I would like to improve:

* Use components for the UI: Each element must be componentized if the project were more extensive. Labels, UITextFields (if they were needed), must be created in independent reusable and preconfigured classes
* Reachability: Offline user scenario should be handled and inform the user
* Improve the error handling
