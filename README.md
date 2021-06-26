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

### Download iOS SDK Streaming
Download **iOSSDKStreaming** file from [VdoTok SDK](https://sdk.vdotok.com/IOS-SDKs/)

### Code Setup
*	Click on **Code** button 
*	From HTTPS section copy repo URL 
*	Open terminal
*	Go to Desktop directory by typing `cd Desktop` and hit enter
*	And then type `git clone paste_copied_ url` and hit enter
*	After cloning is complete, go to demo project’s root directory by typing `cd path_to_ cloned_project` and hit enter
*	Once inside the project’s root directory type `ls` (LS in small letters) and hit enter and you should see a file named **Podfile**
*	Type command `pod install` hit enter and wait until the process is complete
*	Copy the downloaded **iOSSDKStreaming** to frameworks folder present in the root directory of the cloned project. See attached screenshots
<img width="618" alt="Step1" src="https://user-images.githubusercontent.com/2145411/123523346-72141500-d6dc-11eb-9fc2-cda043d83ea0.png">
<img width="618" alt="Step2" src="https://user-images.githubusercontent.com/2145411/123523881-409d4880-d6e0-11eb-8b61-25b7e5d59361.png">

*	open .xcworkspace file by double clicking it
*	In the opened xcworkspace file, drag and drop the SDK present in the framework folder of the cloned project to the Frameworks folder of the main project, make sure to uncheck copy if needed option, see the attached screen shot.
<img width="618" alt="Step3" src="https://user-images.githubusercontent.com/2145411/123523805-a4734180-d6df-11eb-80b1-f421dc960949.png">
<img width="618" alt="Step7" src="https://user-images.githubusercontent.com/2145411/123524830-3d0cc000-d6e6-11eb-8379-e9c18b46d294.png">
<img width="618" alt="Step4" src="https://user-images.githubusercontent.com/2145411/123524013-0c765780-d6e1-11eb-84aa-081bb7331bf3.png">
<img width="618" alt="Step5" src="https://user-images.githubusercontent.com/2145411/123524027-231cae80-d6e1-11eb-96fe-ab8c4c70ab7e.png">

* Select the main project in xcworkspace file and in the general tab scroll to Frameworks, Libraries, and Embedded Content Section, make sure Embed & Sign is selected in Embed column next to our added SDK (.framework) 

<img width="618" alt="Step6" src="https://user-images.githubusercontent.com/2145411/123524059-3c255f80-d6e1-11eb-9ecc-36a7f91616e2.png">

### Updating  Project ID and Authentication Token
Get Project ID and Authentication Token from [Admin Panel](https://vdotok.com)

Open .xcworkspace file in Xcode. In struct AuthenticationConstants Replace the values for PROJECTID  and AUTHTOKEN with your values

### Building On Device
*iOSSDKStreaming does not work for simulator*

To run on a real device, connect your device with MacBook pro and select your device from the dropdown menu in Xcode.
[Follow this link](https://codewithchris.com/deploy-your-app-on-an-iphone/) for details on how to run application on a real device



	     
