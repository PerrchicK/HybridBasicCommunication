# Hybrid Basic Communication Example
A simple demonstration (in iOS) of the basic communication between the web parts the native parts in hybrid apps.

Mobile applications with main features runinng on web pages called hybrid applications, it gives their owners the ability to change visibility and behaviour without the need to update the app from the store. A hybrid application hosts a web view that aware of the fact that it's being hosted and communicates with the hosting app. The first popular framework that made it possible made by [PhoneGap|http://phonegap.com/], using [Cordova|https://cordova.apache.org/] library, they supplied an easy communication between the web components and the native components.

This is a lite project which demonstrates (in iOS) the basic communication I described above.

You can find here examples for:
- A native-web communication [protocol|https://github.com/PerrchicK/HybridBasicCommunication/blob/master/HybridBasicCommunication/ViewController.swift#L11] so the web and native could "talk" (using the UIWebViewDelegate in iOS, in Android it would be WebViewClient).
- Code injection (Javascript) from the hosting app to the hosted web page.
- Method swizzling in javascript.

![web<->native](https://github.com/PerrchicK/HybridBasicCommunication/blob/master/HybridBasicCommunication/hybrid-communication.png)
