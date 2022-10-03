# VisionBoard

## Screens

Screen 1: Intro of the app with name & logo

Screen 2: Ask users to input their name. Mandatory

Screen 3: Name your vision board or select from the given options. Mandatory

Screen 4: Add a section to your vision board. Mandatory

Screen 5: Vision board with empty section. Section contains 4 empty tiles by default

Screen 6: Section detail page (Empty case)

Screen 7: Fetch images for the section title and let users select upto 5 images

Section 8: Section detail page with attached images


## Notes

1) The app is not configured for dark mode as the UI is provided only for light mode

2) The app keeps the memory and disk usage at the max at 500mb.. Only incase of the image search using Pexels API which requires to download and cache the images to keep the network usage minimal. Kingfisher module has been used to do so

3) The caption input is ambiguous and hence is not implemented until further update on this

4) I have implemented pagination, I dont know if its necessary but I did implement pagination as well as shimmer for images while they load.

5) RealmSwift has notable issue which has not been resolved in Xcode 14.1 stable version. The issue is "Publishing changes from within view updates is not allowed, this will cause undefined behaviour". This issue seems to be resolved in Xcode 14.1 Beta 3. If you encounter this, it is safe to ignore. However i have skipped some MVVM architecture to avoid this bug which seems to have occurance on a complete constraint to MVVM architecture.

6) Some ViewModel classes have no implementation as they could be used for future needs.

7) Initially, I removed the API key, but then to test it out on your device, It is necessary, hence i then force pushed it by ignoring the git ignore/
