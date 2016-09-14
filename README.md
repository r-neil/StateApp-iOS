#State Details iOS App

This iOS app pull from a REST API and displays the data of the user's choosing.


#Usage

Clone Repo.

Requires Xcode 7.3 (iOS 9.x)

Update End Point to use in APIHelper.swift.
Class assumes you're using Statepp-backend (https://github.com/r-neil/StatesApp-backend).

``` swift

///Update "http" string
extension String{
var createAPIStr: String {return "https://stateapp.herokuapp.com/" + self}
}

```

Run App in Xcode Simulator and on your phone.

#Example Screen Shot
![Screenshot](https://github.com/r-neil/StateApp-iOS/blob/master/Img/screenshot.png)
