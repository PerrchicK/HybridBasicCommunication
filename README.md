# Hybrid Basic Communication Example
Mobile applications that include web pages as main features called hybrid applications, it gives them the ability to change visibility and behaviour without the need to update the app from the store. The application is hosting a web view that aware of the fact it's being hosted, and communicates with the hosting app. The first famous framework that made it possible made by PhoneGap, using Cordova library, they supplied a communication between the web components and the native components.

This is a lite project which demonstrates (in iOS) the basic communication I described above.

You can find here examples for:
- A native-web communication protocol so the web and native could talk (using UIWebViewDelegate, in Android it would be WebViewClient)
- Code injection (Javascript) from the hosting app to the hosted web page
- Method swizzling

![web<->native](https://github.com/PerrchicK/HybridBasicCommunication/blob/master/HybridBasicCommunication/hybrid-communication.png)
