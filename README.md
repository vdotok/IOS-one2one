# IOS-one2one
iOSSDKStreaming-one2one

## Installation

### Requirements
##### System Requirements
* OS X 11.0 or later
* 8GB of ram memory
   
##### Development Requirements
* Xcode 12+
* [How to Install Xcode](https://www.freecodecamp.org/news/how-to-download-and-install-xcode/) Follow the guidelines in the link to install Xcode - we recommend to install Xcode from App Store 

### Installing Cocoapods
Open terminal and type command `pod --version` and hit enter. If command is not found then you don’t have cocoapods installed on your system.
#### Installing Cocoapods
* Type the following command in terminal `sudo gem install cocoapods` and hit enter
* After installation is complete, type command `pod --version` and hit enter to confirm installation is successful

### Project Signup and Project ID
Register at [VdoTok HomePage](https://vdotok.com) to get Authentication Token and Project ID

### Code Setup
*	Click on **Code** button 
*	From HTTPS section copy repo URL 
*	Open terminal
*	Go to Desktop directory by typing `cd Desktop` and hit enter
*	And then type `git clone paste_copied_ url` and hit enter
*	After cloning is complete, go to demo project’s root directory by typing `cd path_to_ cloned_project` and hit enter
*	Once inside the project’s root directory type `ls` (LS in small letters) and hit enter and you should see a file named **Podfile**
*	Type command `pod install` hit enter and wait until the process is complete
*	open .xcworkspace file by double clicking it

### Updating  Project ID and Authentication Token
Get Project ID and Authentication Token from [Admin Panel](https://vdotok.com)

Open .xcworkspace file in Xcode. In struct AuthenticationConstants Replace the values for PROJECTID  and AUTHTOKEN with your values

### Building On Device
*iOSSDKStreaming does not work for simulator*

To run on a real device, connect your device with MacBook pro and select your device from the dropdown menu in Xcode.
[Follow this link](https://codewithchris.com/deploy-your-app-on-an-iphone/) for details on how to run application on a real device
