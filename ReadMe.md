# Trivia2

[![N|Solid](https://opentdb.com/images/logo-banner.png)](https://nodesource.com/products/nsolid)

Trivia2 is a trivia game, it uses [Open Trivia Database](https://opentdb.com) api as the knowledge provider, you can configure the game as you want, depending on the api options: (https://opentdb.com/api_config.php). Some of the settings you can set are difficulty, category, number of questions. Also the game stores your previous games and answers.

# Implementations
The app contains the next view controllers:
  - HomeScreen
  - Login and SignUp screen
  - TabBarController with the next ViewControllers:
    - Game, where you can configure and start a new game
    - History, is a TableViewController where you can check your previous games, and if you select one you navigate to a ViewController that contains a TableView with the questions, answers and your selected options of the selected game
    -  Profile, a small page where you can manage your account, to change your password or profile picture

# How to build
The app use some external components imported from cocoa pods, including Firebase libraries to create your game account.

##### Requirements
You need to have the next configuration on your computer:
    - XCode Version 11.4.1
    - Swift 5

Also, you will need the latest CocoaPods on your computer, for this installing, follow the steps on this tutorial: [Install CocoaPods](https://guides.cocoapods.org/using/getting-started.html#toc_3)

Once installed follow the next steps:
    
##### Steps

    1. Download the app from github
    2. Open a console on your download folder ".../projects/ios/Trivia2"
    3. Run the next command: 
    'pod install'
    4. Wait until it finish, this could take some time
    5. Once finish open XCode and open the file 'Trivia2.xcworkspace'
    6. Important do not use the usual 'Trivia2.xcodeproj'


