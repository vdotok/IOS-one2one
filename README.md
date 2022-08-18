# IOS-one2one
iOSSDKStreaming-one2one Audio/Video Call

## Installation

### Requirements
##### System Requirements
* OS X 11.0 or later
* 8GB of RAM memory
   
##### Development Requirements
* Xcode 13.4.1 or latest version
* [Click here](https://developer.apple.com/xcode/resources/) to download Xcode on your macbook.


### Installing Cocoapods
Open **Terminal** and type command `pod --version` and hit **Enter**. 

If command is not found then you don’t have Cocoapods installed on your system. To install Cocoapods, follow the below steps:
#### Installing Cocoapods

* Type the following command in **Terminal** `sudo gem install cocoapods` and hit **Enter**
* After installation is complete, type command `pod --version` and hit **Enter** to confirm installation is successful

### Project Signup and Project ID
Register at [VdoTok HomePage](https://vdotok.com) to get **TENANT TESTING SERVER** and **PROJECT ID**

### Code Setup
*	Click on **Code** button 
*	From HTTPS section, copy **repo URL**
*	Open **Terminal**
*	Go to Desktop **Directory** by typing `cd Desktop` and hit **Enter**
*	And then type `git clone https://github.com/vdotok/IOS-one2one.git` and hit **Enter**
*	After cloning is complete, go to **Demo project’s root directory** by typing `cd path_to_ 		cloned_project` and hit **Enter**
*	Once inside the project’s root directory type `ls` (LS in small letters) and hit **Enter**. You 	should be able to see a file named **Podfile**
*	Type command `pod install` > hit **Enter** and wait until the process is complete
*  Once the process is completed it should look like following
<img width="500" alt="Screenshot 2022-08-16 at 12 11 20 PM" src="https://user-images.githubusercontent.com/111276411/185377295-4d89b167-6761-424b-aaa2-1c784e80cc62.png">


### Updating  Project ID and Authentication Token
*  Get **Project ID** and **TENANT TESTING SERVER** from [Admin Panel](https://userpanel.vdotok.com/login)
*  Double-click to open **.xcworkspace file** in Xcode
*  In struct AuthenticationConstants (iOS-one2one -> common -> constants), replace the values for **PROJECTID** and **TENANT TESTING SERVER** with your values

### Building On Device
*Please be noted that iOSSDKStreaming does not work for iOS Simulator*

To run on a real device:

  * Connect your device with MacBook
  * Select your device from the dropdown menu in Xcode

For details on how to run application on a real device, please [click here](https://codewithchris.com/deploy-your-app-on-an-iphone/) to follow instructions. 
